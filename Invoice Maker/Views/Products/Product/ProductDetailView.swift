//
//  ProductDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 30/05/2025.
//

import SwiftData
import SwiftUI

struct ProductDetailView: View {
    @Query private var invoices: [InvoiceN]
    @State private var selectedInvoice: InvoiceN?
    var product: Product

    @Binding var isEditing: Bool

    init(product: Product, isEditing: Binding<Bool>) {
        self.product = product
        _isEditing = isEditing

        let productId = product.id
        let predicate = #Predicate<InvoiceN> { $0.items.contains { $0.productId == productId } }

        _invoices = Query(filter: predicate, sort: \.createdDate, order: .reverse)
    }

    var body: some View {
        List {
            Section {
                LabeledContent("کد", value: product.code, format: .number)
            }

            Section {
                LabeledContent("نام", value: product.name)
                LabeledContent("قیمت", value: product.price, format: .currencyFormatter(code: product.currency))
                LabeledContent("نوع ارز", value: product.currency.label)
            }

            Section {
                LabeledContent("توضیحات", value: product.details?.isEmpty == false ? product.details! : "-")
            }

            Section {
                ForEach(invoices) { invoice in
                    Button {
                        selectedInvoice = invoice
                    } label: {
                        InvoiceRowView(invoice: invoice)
                    }
                }
            } header: {
                Text("فاکتورها")
            } footer: {
                if invoices.isEmpty {
                    HStack {
                        Spacer()

                        Text("فاکتوری با کد این محصول وجود ندارد.")
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(product.name)
        .sheet(item: $selectedInvoice) { invoice in
            InvoiceSummaryView(invoice: invoice)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("ویرایش") {
                    isEditing.toggle()
                }
            }
        }
    }
}

// #Preview {
//    ProductDetailView()
// }
