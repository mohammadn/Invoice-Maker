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
            NavigationLink(value: customer) {
                HStack {
                    Text(customer.name)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Text(customer.phone?.toPersian() ?? "-")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
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
