//
//  InvoiceFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData
import SwiftUI

struct StandaloneInvoiceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Customer.name) private var customers: [Customer]
    @Query private var business: [Business]
    @State private var showInvoiceProductSelection: Bool = false
    @State private var showCustomerFormView: Bool = false
    @State private var invoiceDetails: StandaloneInvoiceDetails
    @State private var generatedPDF: URL?
    @State private var showDismissAlert: Bool = false

    let invoice: StandaloneInvoice?
    var onSave: (StandaloneInvoiceDetails) -> Void

    init(invoice: StandaloneInvoice? = nil, onSave: @escaping (StandaloneInvoiceDetails) -> Void) {
        self.invoice = invoice

        if let invoice {
            _invoiceDetails = State(initialValue: StandaloneInvoiceDetails(from: invoice))
        } else {
            _invoiceDetails = State(initialValue: StandaloneInvoiceDetails())
        }

        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
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

                if let generatedPDF {
                    Section {
                        ShareLink("پرینت", item: generatedPDF)
                    }
                }
            }
            .navigationBarTitle("فاکتور جدید")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره") {
                        onSave(invoiceDetails)

                        dismiss()
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
                            dismiss()
                        }
                    }
                    .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
                        Button("انصراف", role: .cancel) {
                            showDismissAlert.toggle()
                        }
                        Button("بازگشت") {
                            dismiss()
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
                StandaloneInvoiceProductSelection(items: $invoiceDetails.items)
            }
            .onAppear {
                guard let invoice else { return }

                if let business = business.first {
                    let pdf = PDF(invoice: invoice, business: business)

                    generatedPDF = pdf.generatePDF()
                }
            }
        }
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
