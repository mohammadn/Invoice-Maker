//
//  CustomerView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/04/2025.
//

import SwiftUI

struct CustomerView: View {
    @State var isEditing: Bool = false

    var customer: CustomerN

    var body: some View {
        NavigationStack {
            if isEditing {
                CustomerFormView(customer: customer) {
                    isEditing.toggle()
                }
            } else {
                CustomerDetailView(customer: customer, isEditing: $isEditing)
            }
        }
        .animation(.default, value: isEditing)
    }
}

// #Preview {
//    CustomerView()
// }
