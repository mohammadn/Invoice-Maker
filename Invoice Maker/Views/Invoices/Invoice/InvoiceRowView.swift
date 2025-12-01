//
//  InvoiceRowView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 02/07/2025.
//

import SwiftUI

struct InvoiceRowView: View {
    let invoice: InvoiceN

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(invoice.number ?? "-")
                    .lineLimit(1)
                    .foregroundColor(.primary)

                Spacer()

                Text(invoice.totalWithDiscount, format: .currencyFormatter(code: invoice.currency ?? Currency.IRR))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Image(systemName: "info.circle")
            }

            if let date = invoice.date {
                Text(date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            } else {
                Text("-")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#if DEBUG
    #Preview {
        List {
            InvoiceRowView(invoice: InvoiceN.sampleData[0])
        }
        .modelContainer(previewContainer)
    }
#endif
