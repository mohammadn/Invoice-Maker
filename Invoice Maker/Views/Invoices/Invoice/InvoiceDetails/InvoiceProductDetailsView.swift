//
//  InvoiceProductDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 29/06/2025.
//

import SwiftUI

struct InvoiceProductDetailsView: View {
    let invoice: InvoiceN

    var body: some View {
        ForEach(invoice.items) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text(item.productName)
                        .lineLimit(1)

                    Spacer()

                    Text(item.quantity, format: .number)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(item.productPrice, format: .currencyFormatter(code: item.productCurrency))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
        }
    }
}

// #Preview {
//    InvoiceProductDetailsView()
// }
