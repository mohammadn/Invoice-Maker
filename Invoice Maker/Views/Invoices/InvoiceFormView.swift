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
    @State private var showInvoiceProductSelection: Bool = false
    @State private var invoiceDetails: InvoiceDetails

    var onSave: (InvoiceDetails) -> Void
    var viewer: Bool

    init(invoice: Invoice? = nil, onSave: @escaping (InvoiceDetails) -> Void, viewer: Bool = false) {
        if let invoice {
            _invoiceDetails = State(initialValue: InvoiceDetails(from: invoice))
        } else {
            _invoiceDetails = State(initialValue: InvoiceDetails())
        }

        self.onSave = onSave
        self.viewer = viewer
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("شماره فاکتور*", text: $invoiceDetails.number)
                        .keyboardType(.numberPad)

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
                    ForEach(invoiceDetails.items, id: \.product) { item in
                        let quantity = Binding(
                            get: { item.quantity },
                            set: { invoiceDetails.items[invoiceDetails.items.firstIndex(where: { $0.product == item.product })!].quantity = $0 }
                        )

                        Stepper(value: quantity, step: 1) {
                            Text(item.product.name)
                            Text(quantity.wrappedValue.description)
                        }
                    }
                } header: {
                    HStack {
                        Text("محصولات")
                        Spacer()
                        Button("اضافه", systemImage: "plus") {
                            showInvoiceProductSelection.toggle()
                        }
                    }
                }

                if viewer {
                    Section {
                        Button("پرینت") {
                        }
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
        }
    }
}

#Preview {
    InvoiceFormView { _ in }
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
