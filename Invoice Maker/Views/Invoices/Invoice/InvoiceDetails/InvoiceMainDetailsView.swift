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
            LabeledContent("شماره فاکتور", value: invoice.number ?? "-")
            LabeledContent("نوع فاکتور", value: invoice.type?.label ?? "-")
            LabeledContent("نوع ارز", value: invoice.currency?.label ?? "-")
            if let date = invoice.date {
                LabeledContent("تاریخ صدور", value: date, format: .dateTime)
            } else {
                LabeledContent("تاریخ صدور", value: "-")
            }
            if let options = invoice.options, options.contains(.dueDate), let dueDate = invoice.dueDate {
                LabeledContent("تاریخ سررسید", value: dueDate, format: .dateTime)
            } else {
                LabeledContent("تاریخ سررسید", value: "-")
            }
            LabeledContent("جمع کل", value: invoice.total, format: .currencyFormatter(code: invoice.currency ?? Currency.IRR))
            LabeledContent("ارزش افزوده", value: invoice.vat ?? 0, format: .percent)
            LabeledContent("تخفیف", value: invoice.discount ?? 0, format: .percent)
            LabeledContent("مبلغ نهایی", value: invoice.totalWithDiscount, format: .currencyFormatter(code: invoice.currency ?? Currency.IRR))
            LabeledContent("توضیحات", value: invoice.note?.isEmpty == false ? invoice.note! : "-")
        }
    }
}

#if DEBUG
    #Preview {
        List {
            InvoiceMainDetailsView(invoice: InvoiceN.sampleData[0])
        }
        .modelContainer(previewContainer)
    }
#endif
