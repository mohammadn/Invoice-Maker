//
//  CustomerDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/05/2025.
//

import SwiftData
import SwiftUI

struct CustomerDetailView: View {
    @Query private var invoices: [Invoice]
    @State private var selectedInvoice: Invoice?
    var customer: Customer

    @Binding var isEditing: Bool

    init(customer: Customer, isEditing: Binding<Bool>) {
        self.customer = customer
        _isEditing = isEditing

        let customerId = customer.id
        let predicate = #Predicate<Invoice> {
            $0.customer?.id != nil && $0.customer?.id == customerId
        }

        _invoices = Query(filter: predicate, sort: \.createdDate, order: .reverse)
    }

    var body: some View {
        List {
            Section {
                LabeledContent("نام", value: customer.name)
                LabeledContent("شماره تماس", value: customer.phone?.toPersian() ?? "-")
            }

            Section {
                LabeledContent("ایمیل", value: customer.email ?? "-")
                LabeledContent("آدرس", value: customer.address ?? "-")
            }

            Section {
                LabeledContent("توضیحات", value: customer.details?.isEmpty == false ? customer.details! : "-")
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

                        Text("فاکتوری با نام این مشتری وجود ندارد.")
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(customer.name)
        .sheet(item: $selectedInvoice) { invoice in
            InvoiceSummaryView(invoice: invoice)
        }
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
