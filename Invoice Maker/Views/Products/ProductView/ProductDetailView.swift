//
//  ProductDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 30/05/2025.
//

import SwiftData
import SwiftUI

struct ProductDetailView: View {
    @Query private var invoices: [StandaloneInvoice]
    var product: Product

    @Binding var isEditing: Bool

    init(product: Product, isEditing: Binding<Bool>) {
        self.product = product
        _isEditing = isEditing

        let productCode = product.code
        let predicate = #Predicate<StandaloneInvoice> {
            $0.items.contains { $0.productCode == productCode }
        }

        _invoices = Query(filter: predicate, sort: \.createdDate, order: .reverse)
    }

    var body: some View {
        List {
            Section {
                LabeledContent("کد", value: product.code, format: .number)
            }

            Section {
                LabeledContent("نام", value: product.name)
                LabeledContent("قیمت", value: product.price, format: .currency(code: "IRR"))
            }

            Section {
                LabeledContent("جزئیات", value: product.details?.isEmpty == false ? product.details! : "-")
            }

            Section {
                ForEach(invoices) { invoice in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(invoice.number)
                                .lineLimit(1)
                                .foregroundColor(.primary)

                            Spacer()

                            Text(invoice.total, format: .currency(code: "IRR"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Text(invoice.date, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
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
