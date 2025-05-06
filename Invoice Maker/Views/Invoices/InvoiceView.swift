//
//  InvoiceView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/04/2025.
//

import SwiftData
import SwiftUI

struct InvoiceView: View {
    @Query private var business: [Business]
    @State private var generatedPDF: URL?
    @State var isEditing: Bool = false

    var invoice: StandaloneInvoice

    var body: some View {
        NavigationStack {
            if isEditing {
                InvoiceFormView(invoice: invoice) {
                    isEditing.toggle()
                }
            } else {
                List {
                    Section {
                        LabeledContent("شماره فاکتور", value: invoice.number)
                        LabeledContent("تاریخ", value: invoice.date, format: .dateTime)
                    }

                    Section {
                        LabeledContent("نوع فاکتور", value: invoice.type.label)
                        LabeledContent("جزئیات", value: invoice.note.isEmpty ? "-" : invoice.note)
                    }

                    Section {
                        LabeledContent("مشتری", value: invoice.customerName ?? "-")
                    }
                    Section("محصولات") {
                        ForEach(invoice.items) { item in
                            LabeledContent(item.productName, value: item.quantity, format: .number)
                        }
                    }

                    if let generatedPDF {
                        Section {
                            ShareLink("پرینت", item: generatedPDF)
                        }
                    }
                }
                .navigationTitle(invoice.number)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                        Button("ویرایش") {
                            isEditing.toggle()
                        }
                    }
                }
                .onAppear {
                    guard !invoice.isInvalid else { return }

                    if let business = business.first {
                        let pdf = PDF(invoice: invoice, business: business)

                        generatedPDF = pdf.generatePDF()
                    }
                }
            }
        }
        .animation(.default, value: isEditing)
    }
}

// #Preview {
//    InvoiceView()
// }
