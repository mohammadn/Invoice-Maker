//
//  InvoiceMainDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 29/06/2025.
//

import SwiftUI

struct InvoiceMainDetailsView: View {
    let invoice: InvoiceN

    var body: some View {
        Section {
            LabeledContent("شماره فاکتور", value: invoice.number)
            LabeledContent("نوع فاکتور", value: invoice.type.label)
            LabeledContent("نوع ارز", value: invoice.currency.label)
            LabeledContent("تاریخ صدور", value: invoice.date, format: .dateTime)
            if invoice.options.contains(.dueDate) {
                LabeledContent("تاریخ سررسید", value: invoice.dueDate, format: .dateTime)
            }
            LabeledContent("جمع کل", value: invoice.total, format: .currencyFormatter(code: invoice.currency))
            LabeledContent("تخفیف", value: invoice.discount, format: .percent)
            LabeledContent("ارزش افزوده", value: invoice.vat, format: .percent)
            LabeledContent("مبلغ نهایی", value: invoice.totalWithVAT, format: .currencyFormatter(code: invoice.currency))
            LabeledContent("توضیحات", value: invoice.note.isEmpty ? "-" : invoice.note)
        }
    }
}

// #Preview {
//    InvoiceMainDetailsView()
// }
