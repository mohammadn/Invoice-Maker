//
//  InvoiceSummaryView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 29/06/2025.
//

import SwiftUI

struct InvoiceSummaryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TabViewModel.self) private var tabViewModel
    @Environment(InvoiceViewModel.self) private var invoiceViewModel
    let invoice: Invoice

    var body: some View {
        NavigationStack {
            List {
                InvoiceMainDetailsView(invoice: invoice)

                ExpandableSectionView {
                    InvoiceCustomerDetailsView(invoice: invoice)
                } header: {
                    Text("مشتری")
                }

                ExpandableSectionView {
                    InvoiceProductDetailsView(invoice: invoice)
                } header: {
                    Text("محصولات")
                }
            }
            .navigationTitle(invoice.number)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("مشاهده در فاکتورها") {
                        Task {
                            await viewInvoice()
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("بستن") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func viewInvoice() async {
        dismiss()
        try? await Task.sleep(nanoseconds: 300000000)
        tabViewModel.selectedTab = .invoices
        try? await Task.sleep(nanoseconds: 300000000)
        invoiceViewModel.selectedInvoice = invoice
    }
}

// #Preview {
//    InvoiceSummaryView()
// }
