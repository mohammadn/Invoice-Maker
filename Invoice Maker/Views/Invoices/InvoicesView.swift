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
    @Query(sort: \InvoiceN.createdDate, order: .reverse) private var invoices: [InvoiceN]
    @State private var showInvoiceFormView: Bool = false
    @State private var editMode: EditMode = .inactive

    var invalidInvoices: [InvoiceN] {
        invoices.filter { $0.isInvalid }
    }

    var validInvoices: [InvoiceN] {
        invoices.filter { !$0.isInvalid }
    }

    var body: some View {
        NavigationSplitView {
            @Bindable var invoiceViewModel = invoiceViewModel
            List(selection: $invoiceViewModel.selectedInvoices) {
                if !invalidInvoices.isEmpty {
                    Section {
                        ForEach(invalidInvoices) { invoice in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(invoice.number)
                                        .lineLimit(1)

                                    Spacer()

                                    Text(invoice.total, format: .currencyFormatter(code: invoice.currency))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .background {
                                    NavigationLink(value: invoice) { EmptyView() }
                                        .opacity(editMode.isEditing ? 0 : 1)
                                }

                                Text(invoice.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .swipeActions {
                                Button("حذف", role: .destructive) {
                                    delete(invoice: invoice)
                                }
                            }
                        }
                    } header: {
                        Text("نامعتبر")
                    } footer: {
                        Text("این فاکتورها به دلیل عدم وجود اطلاعات مشتری یا محصول نامعتبر هستند.")
                    }
                }

                Section {
                    ForEach(validInvoices, id: \.self) { invoice in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(invoice.number)
                                    .lineLimit(1)

                                Spacer()

                                Text(invoice.total, format: .currencyFormatter(code: invoice.currency))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .padding(.trailing, editMode.isEditing ? 0 : 20)
                            }
                            .background {
                                NavigationLink(value: invoice) { EmptyView() }
                                    .opacity(editMode.isEditing ? 0 : 1)
                            }

                            Text(invoice.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions {
                            Button("حذف", role: .destructive) {
                                delete(invoice: invoice)
                            }
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("فاکتورها")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if editMode.isEditing {
                        Button("حذف") {
                            delete(invoices: invoiceViewModel.selectedInvoices)
                            editMode = .inactive
                        }
                        .disabled(invoiceViewModel.selectedInvoices.isEmpty)
                    } else {
                        Button("افزودن", systemImage: "plus") {
                            showInvoiceFormView.toggle()
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button(editMode.isEditing ? "پایان" : "ویرایش") {
                        withAnimation {
                            editMode = editMode.isEditing ? .inactive : .active
                            invoiceViewModel.selectedInvoices.removeAll()
                        }
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
            switch invoiceViewModel.selectedInvoices.count {
            case 0:
                Text("یک فاکتور انتخاب کنید")
                    .font(.title)
            case 1:
                if let invoice = invoiceViewModel.selectedInvoices.first {
                    InvoiceView(invoice: invoice)
                }
            default:
                Text("\(invoiceViewModel.selectedInvoices.count) فاکتور انتخاب شده است")
                    .font(.title)
            }
        }
    }

    private func delete(invoice: InvoiceN) {
        modelContext.delete(invoice)
    }

    private func delete(invoices: Set<InvoiceN>) {
        for invoice in invoices {
            modelContext.delete(invoice)
        }
    }
}

// #Preview {
//    InvoicesView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
