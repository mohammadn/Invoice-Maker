//
//  InvoiceFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData
import SwiftUI

struct InvoiceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Customer.name) private var customers: [Customer]
    @State private var showInvoiceProductSelection: Bool = false
    @State private var showCustomerFormView: Bool = false
    @State private var invoiceDetails: StandaloneInvoiceDetails
    @State private var showDismissAlert: Bool = false

    let invoice: StandaloneInvoice?
    var dismissAction: (() -> Void)?

    init(invoice: StandaloneInvoice, dismissAction: @escaping () -> Void) {
        self.invoice = invoice
        self.dismissAction = dismissAction

        _invoiceDetails = State(initialValue: StandaloneInvoiceDetails(from: invoice))
    }

    init(business: Business? = nil) {
        invoice = nil
        dismissAction = nil

        if let business {
            _invoiceDetails = State(initialValue: StandaloneInvoiceDetails(with: business))
        } else {
            _invoiceDetails = State(initialValue: StandaloneInvoiceDetails())
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("شماره فاکتور*", text: $invoiceDetails.number)

                Picker("نوع فاکتور", selection: $invoiceDetails.type) {
                    ForEach(Invoice.InvoiceType.allCases, id: \.self) { type in
                        Text(type.label)
                            .tag(type)
                    }
                }
            }

            Section {
                Picker("مشتری", selection: $invoiceDetails.customerId) {
                    Text("انتخاب کنید")
                        .tag(nil as UUID?)
                    ForEach(customers) { customer in
                        Text(customer.name)
                            .tag(customer.id as UUID?)
                    }
                }
                .pickerStyle(.navigationLink)
                .disabled(customers.isEmpty)
                .onChange(of: invoiceDetails.customerId) {
                    let customer = customers.first { $0.id == invoiceDetails.customerId }

                    if let customer {
                        invoiceDetails.customerName = customer.name
                        invoiceDetails.customerAddress = customer.address
                        invoiceDetails.customerDetails = customer.details
                        invoiceDetails.customerPhone = customer.phone
                        invoiceDetails.customerEmail = customer.email
                    } else {
                        invoiceDetails.customerName = nil
                        invoiceDetails.customerAddress = nil
                        invoiceDetails.customerDetails = nil
                        invoiceDetails.customerPhone = nil
                        invoiceDetails.customerEmail = nil
                    }
                }

                Button("افزودن مشتری", systemImage: "plus") {
                    showCustomerFormView.toggle()
                }
            }

            Section {
                DatePicker("تاریخ", selection: $invoiceDetails.date)
            }

            Section {
                TextField("توضیحات", text: $invoiceDetails.note, axis: .vertical)
                    .lineLimit(2 ... 4)
            }

            Section {
                ForEach($invoiceDetails.items) { $item in
                    Stepper {
                        Text(item.productName)
                        Text(item.quantity.description)
                    } onIncrement: {
                        item.quantity += 1
                    } onDecrement: {
                        if item.quantity > 0 {
                            item.quantity -= 1
                        }
                    }
                }
                .onDelete(perform: deleteProduct)
            } header: {
                HStack {
                    Text("محصولات")
                    Spacer()
                    Button("افزودن", systemImage: "plus") {
                        showInvoiceProductSelection.toggle()
                    }
                }
            }
        }
        .navigationBarTitle(invoice == nil ? "فاکتور جدید" : "ویرایش فاکتور")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("ذخیره") {
                    save()

                    dismissAction?() ?? dismiss()
                }
                .disabled(invoiceDetails.isInvalid)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("انصراف") {
                    guard let invoice else {
                        showDismissAlert.toggle()
                        return
                    }

                    if StandaloneInvoiceDetails(from: invoice) != invoiceDetails {
                        showDismissAlert.toggle()
                    } else {
                        dismissAction?() ?? dismiss()
                    }
                }
                .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
                    Button("انصراف", role: .cancel) {
                        showDismissAlert.toggle()
                    }
                    Button("بازگشت") {
                        dismissAction?() ?? dismiss()
                    }
                } message: {
                    Text("در صورت بازگشت به صفحه قبل اطلاعات فاکتور ذخیره نخواهد شد.")
                }
            }
        }
        .sheet(isPresented: $showCustomerFormView) {
            NavigationStack {
                CustomerFormView()
            }
        }
        .sheet(isPresented: $showInvoiceProductSelection) {
            InvoiceProductSelection(items: $invoiceDetails.items)
        }
    }

    private func save() {
        invoiceDetails.note = invoiceDetails.note.trimmingCharacters(in: .whitespacesAndNewlines)

        if let invoice {
            invoice.update(with: invoiceDetails)

            invoiceDetails.items.forEach { item in
                if let existingItem = invoice.items.first(where: { $0.productCode == item.productCode }) {
                    existingItem.update(with: item)
                } else {
                    let standaloneItem = StandaloneItem(from: item, invoice: invoice)

                    modelContext.insert(standaloneItem)
                }
            }

            invoice.items.forEach { item in
                if (!invoiceDetails.items.contains { $0.productCode == item.productCode }) {
                    modelContext.delete(item)
                }
            }
        } else {
            let invoice = StandaloneInvoice(from: invoiceDetails)

            modelContext.insert(invoice)

            invoiceDetails.items.forEach { item in
                let standaloneItem = StandaloneItem(from: item, invoice: invoice)

                modelContext.insert(standaloneItem)
            }
        }

        try? modelContext.save()
    }

    private func deleteProduct(at indexSet: IndexSet) {
        indexSet.forEach { index in
            invoiceDetails.items.remove(at: index)
        }
    }
}

// #Preview {
//    InvoiceFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
