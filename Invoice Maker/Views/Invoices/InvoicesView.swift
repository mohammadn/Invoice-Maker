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
    @Environment(InvoiceViewModel.self) private var invoiceViewModel
    @Query private var business: [Business]
    @Query(sort: \Invoice.createdDate, order: .reverse) private var invoices: [Invoice]
    @State private var showInvoiceFormView: Bool = false
    @State private var selectedInvoice: Invoice?

    var invalidInvoices: [Invoice] {
        invoices.filter { $0.isInvalid }
    }

    var validInvoices: [Invoice] {
        invoices.filter { !$0.isInvalid }
    }

    var body: some View {
        NavigationSplitView {
            @Bindable var invoiceViewModel = invoiceViewModel
            List(selection: $invoiceViewModel.selectedInvoice) {
                if !invalidInvoices.isEmpty {
                    Section {
                        ForEach(invalidInvoices) { invoice in
                            VStack(alignment: .leading) {
                                NavigationLink(value: invoice) {
                                    HStack {
                                        Text(invoice.number)
                                            .lineLimit(1)

                                        Spacer()

                                        Text(invoice.total, format: .currencyFormatter(code: invoice.currency))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }

                                Text(invoice.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
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

                                    Text(invoice.total, format: .currencyFormatter(code: invoice.currency))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Text(invoice.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteValidInvoice)
                }
            }
            .navigationTitle("فاکتورها")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
        } detail: {
            if let invoice = invoiceViewModel.selectedInvoice {
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
