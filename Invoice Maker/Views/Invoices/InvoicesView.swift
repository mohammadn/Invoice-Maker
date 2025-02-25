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
    @Query(sort: \Invoice.createdDate, order: .reverse) private var invoices: [Invoice]
    @State private var showInvoiceFormView: Bool = false
    @State private var selectedInvoice: Invoice?

    var body: some View {
        NavigationStack {
            List {
                ForEach(invoices) { invoice in
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

                        Text(invoice.customer.name)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                .onDelete(perform: delete)
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
                InvoiceFormView(onSave: save)
            }
            .sheet(item: $selectedInvoice) { invoice in
                InvoiceFormView(invoice: invoice, onSave: update)
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
        }
    }

    private func save(invoiceDetails: InvoiceDetails) {
        let invoice = Invoice(from: invoiceDetails)

        if let invoice {
            context.insert(invoice)
        }
    }

    private func update(invoiceDetails: InvoiceDetails) {
        selectedInvoice?.update(with: invoiceDetails)
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(invoices[index])
        }
    }
}

// #Preview {
//    InvoicesView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
