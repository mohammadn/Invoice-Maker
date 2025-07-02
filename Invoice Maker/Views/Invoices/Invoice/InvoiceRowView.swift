//
//  InvoiceRowView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 02/07/2025.
//

import SwiftUI

struct InvoiceRowView: View {
    let invoice: VersionedInvoice

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(invoice.number)
                    .lineLimit(1)
                    .foregroundColor(.primary)

                Spacer()

                Text(invoice.total, format: .currencyFormatter(code: invoice.currency))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Image(systemName: "info.circle")
            }

            Text(invoice.date, style: .date)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(1)
        }
    }
}

// #Preview {
//    InvoiceRowView()
// }
