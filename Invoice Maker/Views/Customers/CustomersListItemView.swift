//
//  CustomersListItemView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 26/01/2025.
//

import SwiftUI

struct CustomersListItemView: View {
    let customer: CustomerN

    @Binding var editMode: EditMode

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(customer.name)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                Text(customer.phone?.toPersian() ?? "-")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .padding(.trailing, editMode.isEditing ? 0 : 20)
            }
            .background {
                NavigationLink(value: customer) { EmptyView() }
                    .opacity(editMode.isEditing ? 0 : 1)
            }

            Text(customer.email ?? "-")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(1)
        }
    }
}

#Preview {
    @Previewable @State var editMode: EditMode = .inactive

    NavigationStack {
        List {
            CustomersListItemView(customer: CustomerN.sampleData[0], editMode: $editMode)
        }
    }
}
