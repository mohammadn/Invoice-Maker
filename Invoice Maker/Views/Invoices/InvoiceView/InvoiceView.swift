//
//  InvoiceView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/04/2025.
//

import SwiftData
import SwiftUI

struct InvoiceView: View {
    @Query private var business: [Business]
    @State var isEditing: Bool = false

    var invoice: StandaloneInvoice

    var body: some View {
        NavigationStack {
            if isEditing {
                InvoiceFormView(invoice: invoice) {
                    isEditing.toggle()
                }
            } else {
                InvoiceDetailView(invoice: invoice, isEditing: $isEditing)
            }
        }
        .animation(.default, value: isEditing)
    }
}

// #Preview {
//    InvoiceView()
// }
