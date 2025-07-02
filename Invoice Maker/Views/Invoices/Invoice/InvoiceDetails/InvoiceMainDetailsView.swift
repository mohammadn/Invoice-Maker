//
//  InvoiceMainDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 29/06/2025.
//

import SwiftUI

struct InvoiceMainDetailsView: View {
    let invoice: VersionedInvoice

    var body: some View {
        Section {
            LabeledContent("شماره فاکتور", value: invoice.number)
            LabeledContent("نوع فاکتور", value: invoice.type.label)
            LabeledContent("جمع کل", value: invoice.total, format: .currencyFormatter(code: invoice.currency))
            LabeledContent("نوع ارز", value: invoice.currency.label)
            LabeledContent("تاریخ", value: invoice.date, format: .dateTime)
            LabeledContent("توضیحات", value: invoice.note.isEmpty ? "-" : invoice.note)
        }
    }
}

// #Preview {
//    InvoiceMainDetailsView()
// }
