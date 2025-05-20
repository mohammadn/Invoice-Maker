//
//  InvoiceDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/05/2025.
//

import SwiftData
import SwiftUI

struct InvoiceDetailView: View {
    @State private var generatedPDF: URL?

    var invoice: StandaloneInvoice

    @Binding var isEditing: Bool

    var body: some View {
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
            } footer: {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.yellow)

                    Text("اطلاعات مشتری تغییر کرده است. در صورت نیاز، اطلاعات را بروزرسانی کنید.")
                }
            }

            Section {
                ForEach(invoice.items) { item in
                    LabeledContent(item.productName, value: item.quantity, format: .number)
                }
            } header: {
                Text("محصولات")
            } footer: {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.yellow)

                    Text("اطلاعات یک یا چند محصول تغییر کرده است. در صورت نیاز، اطلاعات را بروزرسانی کنید.")
                }
            }
        }
        .navigationTitle(invoice.number)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                Menu {
                    Button("ویرایش", systemImage: "pencil") {
                        isEditing.toggle()
                    }

                    Button("بروزرسانی اطلاعات مشتری", systemImage: "arrow.trianglehead.clockwise") {
                        isEditing.toggle()
                    }

                    Button("بروزرسانی اطلاعات محصولات", systemImage: "arrow.trianglehead.clockwise") {
                        isEditing.toggle()
                    }
                    
                    Button("بروزرسانی اطلاعات کسب وکار", systemImage: "arrow.trianglehead.clockwise") {
                        isEditing.toggle()
                    }

                    if let generatedPDF {
                        ShareLink("پرینت", item: generatedPDF)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            guard !invoice.isInvalid else { return }

            let pdf = PDF(invoice: invoice)

            generatedPDF = pdf.generatePDF()
        }
    }
}

// #Preview {
//    InvoiceDetailView()
// }
