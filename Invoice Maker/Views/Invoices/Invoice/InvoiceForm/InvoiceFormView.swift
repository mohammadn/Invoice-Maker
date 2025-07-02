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
    @Query private var business: [Business]
    @Query(sort: \Customer.name) private var customers: [Customer]
    @State private var showInvoiceProductSelection: Bool = false
    @State private var showCustomerFormView: Bool = false
    @State private var invoiceDetails: InvoiceDetails
    @State private var showDismissAlert: Bool = false

    let invoice: VersionedInvoice?
    var dismissAction: (() -> Void)?

    init(invoice: VersionedInvoice? = nil, dismissAction: (() -> Void)? = nil) {
        self.invoice = invoice
        self.dismissAction = dismissAction

        if let invoice {
            _invoiceDetails = State(initialValue: InvoiceDetails(from: invoice))
        } else {
            let defaultCurrency = UserDefaults.standard.string(forKey: "defaultCurrency") ?? "IRR"
            let currency = Currency(rawValue: defaultCurrency) ?? .IRR

            _invoiceDetails = State(initialValue: InvoiceDetails(currency: currency))
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

                Picker("نوع ارز", selection: $invoiceDetails.currency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Text(currency.label).tag(currency)
                    }
                }

                DatePicker("تاریخ", selection: $invoiceDetails.date)
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
        .interactiveDismissDisabled()
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

                    if InvoiceDetails(from: invoice) != invoiceDetails {
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
                    let item = VersionedItem(from: item)
                    invoice.items.append(item)
                }
            }

            invoice.items.forEach { item in
                if (!invoiceDetails.items.contains { $0.productCode == item.productCode }) {
                    modelContext.delete(item)
                }
            }
        } else {
            guard let business = business.first else { return }
            let invoiceCustomer = InvoiceCustomer(from: invoiceDetails)
            let invoiceBusiness = InvoiceBusiness(from: business)

            let invoice = VersionedInvoice(from: invoiceDetails, customer: invoiceCustomer, business: invoiceBusiness)

            invoiceDetails.items.forEach {
                let item = VersionedItem(from: $0)
                invoice.items.append(item)
            }

            modelContext.insert(invoice)
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
