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
    @Query(sort: \Customer.name) private var customers: [Customer]
    @Query private var business: [Business]
    @State private var showInvoiceProductSelection: Bool = false
    @State private var invoiceDetails: InvoiceDetails
    @State private var generatedPDF: URL?

    let invoice: Invoice?
    var onSave: (InvoiceDetails) -> Void

    init(invoice: Invoice? = nil, onSave: @escaping (InvoiceDetails) -> Void) {
        self.invoice = invoice

        if let invoice {
            _invoiceDetails = State(initialValue: InvoiceDetails(from: invoice))
        } else {
            _invoiceDetails = State(initialValue: InvoiceDetails())
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
                    Picker("مشتری", selection: $invoiceDetails.customer) {
                        Text("انتخاب کنید")
                            .tag(nil as Customer?)
                        ForEach(customers) { customer in
                            Text(customer.name)
                                .tag(customer as Customer?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(customers.isEmpty)
                }

                Section {
                    DatePicker("تاریخ", selection: $invoiceDetails.date)
                }

                Section {
                    TextField("توضیحات", text: $invoiceDetails.note, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section {
                    ForEach(invoiceDetails.items.indices, id: \.self) { index in
                        Stepper {
                            Text(invoiceDetails.items[index].product.name)
                            Text(invoiceDetails.items[index].quantity.description)
                        } onIncrement: {
                            invoiceDetails.items[index].quantity += 1
                        } onDecrement: {
                            if invoiceDetails.items[index].quantity > 0 {
                                invoiceDetails.items[index].quantity -= 1
                            }
                        }
                    }
                    .onDelete(perform: deleteProduct)
                } header: {
                    HStack {
                        Text("محصولات")
                        Spacer()
                        Button("اضافه", systemImage: "plus") {
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره") {
                        onSave(invoiceDetails)
                        dismiss()
                    }
                    .disabled(invoiceDetails.isInvalid)
                }
            }
            .sheet(isPresented: $showInvoiceProductSelection) {
                InvoiceProductSelection(items: $invoiceDetails.items)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .onAppear {
                if let invoice,
                   let business = business.first {
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
