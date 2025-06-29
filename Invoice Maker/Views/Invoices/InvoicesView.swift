//
//  InvoicesView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import SwiftData
import SwiftUI

struct InvoicesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [Business]
    @Query private var oldInvoices: [Invoice]
    @Query(sort: \VersionedInvoice.createdDate, order: .reverse) private var invoices: [VersionedInvoice]
    @State private var showInvoiceFormView: Bool = false
    @State private var selectedInvoice: VersionedInvoice?

    var invalidInvoices: [VersionedInvoice] {
        invoices.filter { $0.isInvalid }
    }

    var validInvoices: [VersionedInvoice] {
        invoices.filter { !$0.isInvalid }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedInvoice) {
                if !invalidInvoices.isEmpty {
                    Section {
                        ForEach(invalidInvoices) { invoice in
                            VStack(alignment: .leading) {
                                NavigationLink(value: invoice) {
                                    HStack {
                                        Text(invoice.number)
                                            .lineLimit(1)

                                        Spacer()

                                        Text(invoice.date, style: .date)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Text(invoice.customer?.name ?? "-")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .onDelete(perform: deleteInvalidInvoice)
                    } header: {
                        Text("نامعتبر")
                    } footer: {
                        Text("این فاکتورها به دلیل عدم وجود اطلاعات مشتری یا محصول نامعتبر هستند.")
                    }
                }

                Section {
                    ForEach(validInvoices) { invoice in
                        VStack(alignment: .leading) {
                            NavigationLink(value: invoice) {
                                HStack {
                                    Text(invoice.number)
                                        .lineLimit(1)

                                    Spacer()

                                    Text(invoice.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Text(invoice.customer?.name ?? "-")
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
                    Button("افزودن فاکتور", systemImage: "plus") {
                        showInvoiceFormView.toggle()
                    }
                }
            }
            .sheet(isPresented: $showInvoiceFormView) {
                NavigationStack {
                    InvoiceFormView()
                }
            }
            .overlay {
                if invoices.isEmpty {
                    ContentUnavailableView {
                        Label("فاکتوری یافت نشد", systemImage: "doc.text")
                    } description: {
                        Text("برای افزودن فاکتور جدید روی دکمه + کلیک کنید")
                    }
                }
            }
            .onAppear {
                oldInvoices.forEach { invoice in
                    let items: [VersionedItem] = invoice.items.compactMap { item in
                        let productModelID = item.product.persistentModelID
                        let descriptor = FetchDescriptor<Product>(predicate: #Predicate { product in product.persistentModelID == productModelID })
                        let results = try? modelContext.fetch(descriptor)

                        if results?.isEmpty ?? true {
                            return nil
                        } else {
                            return VersionedItem(from: item)
                        }
                    }

                    let customerModelID = invoice.customer.persistentModelID
                    let descriptor = FetchDescriptor<Customer>(predicate: #Predicate { customer in customer.persistentModelID == customerModelID })
                    let results = try? modelContext.fetch(descriptor)

                    guard let business = business.first else { return }

                    let invoiceBusiness = InvoiceBusiness(from: business)
                    let invoiceCustomer = InvoiceCustomer(from: invoice.customer)

                    let versionedInvoice = VersionedInvoice(from: invoice,
                                                            items: items,
                                                            customer: results?.isEmpty ?? true ? nil : invoiceCustomer,
                                                            business: invoiceBusiness)

                    modelContext.insert(versionedInvoice)
                    modelContext.delete(invoice)
                }
            }
        } detail: {
            if let invoice = selectedInvoice {
                InvoiceView(invoice: invoice)
            } else {
                Text("یک فاکتور را انتخاب کنید")
                    .font(.title)
            }
        }
    }

    private func deleteInvalidInvoice(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(invalidInvoices[index])
        }
    }

    private func deleteValidInvoice(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(validInvoices[index])
        }
    }
}

// #Preview {
//    InvoicesView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
