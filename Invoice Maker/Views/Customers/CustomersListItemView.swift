//
//  CustomersListItemView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 26/01/2025.
//

import SwiftUI

struct CustomersListItemView: View {
    @Binding var selectedCustomer: Customer?
    let customer: Customer

    var body: some View {
        VStack(alignment: .leading) {
            LabeledContent {
                HStack {
                    Text(customer.phone ?? "-")
                        .lineLimit(1)

                    Button {
                        selectedCustomer = customer
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                    }
                }
            } label: {
                Text(customer.name)
                    .lineLimit(1)
            }

            Text(customer.email ?? "-")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(1)
        }
    }
}

// #Preview {
//    CustomersListItemView()
// }
