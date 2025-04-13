//
//  InvoicesView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import SwiftData
import SwiftUI

struct InvoicesView: View {
    @Environment(\.modelContext) private var context
    @Query private var business: [Business]
    @Query private var invoices: [Invoice]
    @Query(sort: \StandaloneInvoice.createdDate, order: .reverse) private var standaloneInvoices: [StandaloneInvoice]
    @State private var showInvoiceFormView: Bool = false
    @State private var selectedInvoice: StandaloneInvoice?

    var invalidInvoices: [StandaloneInvoice] {
        standaloneInvoices.filter { $0.isInvalid }
    }

    var validInvoices: [StandaloneInvoice] {
        standaloneInvoices.filter { !$0.isInvalid }
    }

    var body: some View {
        NavigationStack {
            List {
                if !invalidInvoices.isEmpty {
                    Section {
                        ForEach(invalidInvoices) { invoice in
                            VStack(alignment: .leading) {
                                LabeledContent {
                                    HStack {
                                        Text(invoice.date, style: .date)

                                        Button {
                                            selectedInvoice = invoice
                                        } label: {
                                            Image(systemName: "info.circle")
                                                .font(.title3)
                                        }
                                    }
                                } label: {
                                    Text(invoice.number)
                                        .lineLimit(1)
                                }

                                Text(invoice.customerName ?? "-")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .onDelete(perform: deleteInvalidInvoice)
                    } header: {
                        Text("نامعتبر")
                    } footer: {
                        Text("این فاکتورها به دلیل عدم وجود مشتری یا محصول نامعتبر هستند.")
                    }
                }

                Section {
                    ForEach(validInvoices) { invoice in
                        VStack(alignment: .leading) {
                            LabeledContent {
                                HStack {
                                    Text(invoice.date, style: .date)

                                    Button {
                                        selectedInvoice = invoice
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.title3)
                                    }
                                }
                            } label: {
                                Text(invoice.number)
                                    .lineLimit(1)
                            }

                            Text(invoice.customerName ?? "-")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                    }
                    .onDelete(perform: deleteValidInvoice)
                }
            }
            .navigationBarTitle("فاکتورها")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("اضافه", systemImage: "plus") {
                        showInvoiceFormView.toggle()
                    }
                }
            }
            .sheet(isPresented: $showInvoiceFormView) {
                StandaloneInvoiceFormView(onSave: save)
            }
            .sheet(item: $selectedInvoice) { invoice in
                StandaloneInvoiceFormView(invoice: invoice, onSave: update)
            }
            .overlay {
                if standaloneInvoices.isEmpty {
                    ContentUnavailableView {
                        Label("فاکتوری یافت نشد", systemImage: "doc.text")
                    } description: {
                        Text("برای افزودن فاکتور جدید روی دکمه + کلیک کنید")
                    }
                }
            }
            .onAppear {
                invoices.forEach { invoice in
                    let items: [StandaloneItem] = invoice.items.compactMap { item in
                        let productModelID = item.product.persistentModelID
                        let descriptor = FetchDescriptor<Product>(predicate: #Predicate { product in product.persistentModelID == productModelID })
                        let results = try? context.fetch(descriptor)

                        if results?.isEmpty ?? true {
                            return nil
                        } else {
                            return StandaloneItem(from: item)
                        }
                    }

                    let customerModelID = invoice.customer.persistentModelID
                    let descriptor = FetchDescriptor<Customer>(predicate: #Predicate { customer in customer.persistentModelID == customerModelID })
                    let results = try? context.fetch(descriptor)

                    guard let business = business.first else { return }

                    let standaloneInvoice = StandaloneInvoice(from: invoice,
                                                              business: business,
                                                              items: items,
                                                              customer: results?.isEmpty ?? true ? nil : invoice.customer)

                    context.insert(standaloneInvoice)
                    context.delete(invoice)
                }
            }
        }
    }

    private func save(invoiceDetails: StandaloneInvoiceDetails) {
        let invoice = StandaloneInvoice(from: invoiceDetails)

        if let invoice {
            context.insert(invoice)
        }
    }

    private func update(invoiceDetails: StandaloneInvoiceDetails) {
        selectedInvoice?.update(with: invoiceDetails)
    }

    private func deleteInvalidInvoice(at offsets: IndexSet) {
        for index in offsets {
            context.delete(invalidInvoices[index])
        }
    }

    private func deleteValidInvoice(at offsets: IndexSet) {
        for index in offsets {
            context.delete(validInvoices[index])
        }
    }
}

// #Preview {
//    InvoicesView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
