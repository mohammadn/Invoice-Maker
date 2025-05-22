//
//  CustomerDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/05/2025.
//

import SwiftData
import SwiftUI

struct CustomerDetailView: View {
    @Query private var invoices: [StandaloneInvoice]
    var customer: Customer

    @Binding var isEditing: Bool

    init(customer: Customer, isEditing: Binding<Bool>) {
        self.customer = customer
        _isEditing = isEditing

        let customerId = customer.id
        let predicate = #Predicate<StandaloneInvoice> {
            $0.customerId != nil && $0.customerId == customerId
        }

        _invoices = Query(filter: predicate, sort: \.createdDate, order: .reverse)
    }

    var body: some View {
        List {
            Section {
                LabeledContent("نام", value: customer.name)
                LabeledContent("تلفن", value: customer.phone?.toPersian() ?? "-")
            }

            Section {
                LabeledContent("ایمیل", value: customer.email ?? "-")
                LabeledContent("آدرس", value: customer.address ?? "-")
            }

            Section {
                LabeledContent("جزئیات", value: customer.details?.isEmpty == false ? customer.details! : "-")
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

                        Text("فاکتوری با نام این مشتری وجود ندارد.")
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(customer.name)
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
//    CustomerDetailView()
// }
