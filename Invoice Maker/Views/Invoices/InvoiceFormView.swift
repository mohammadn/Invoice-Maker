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
    @Environment(\.modelContext) private var context
    @Query(sort: \Customer.name) private var customers: [Customer]
    @State private var showInvoiceProductSelection: Bool = false
    @State private var number: String = ""
    @State private var selectedCustomer: Customer?
    @State private var date: Date = .now
    @State private var note: String = ""
    @State private var type: Invoice.InvoiceType = .sale
    @State private var items: [(product: Product, quantity: Int)] = []
    private var isSaveDisabled: Bool {
        number.isEmpty || selectedCustomer == nil || items.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("شماره فاکتور*", text: $number)
                        .keyboardType(.numberPad)
                    
                    Picker("نوع فاکتور", selection: $type) {
                        ForEach(Invoice.InvoiceType.allCases, id: \.self) { type in
                            Text(type.label)
                                .tag(type)
                        }
                    }
                }

                Section {
                    Picker("مشتری", selection: $selectedCustomer) {
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
                    DatePicker("تاریخ", selection: $date)
                }

                Section {
                    TextField("توضیحات", text: $note, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section {
                    ForEach(items, id: \.product) { item in
                        let quantity = Binding(
                            get: { item.quantity },
                            set: { items[items.firstIndex(where: { $0.product == item.product })!].quantity = $0 }
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
                        save()
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                }
            }
            .sheet(isPresented: $showInvoiceProductSelection) {
                InvoiceProductSelection(items: $items)
                    .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }

    private func save() {
        guard let selectedCustomer else { return }

        let invoice = Invoice(number: number, customer: selectedCustomer, date: date, note: note, type: type)

        items.forEach { item in
            invoice.items.append(Item(product: item.product, quantity: item.quantity))
        }

        context.insert(invoice)
    }
}

#Preview {
    InvoiceFormView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
