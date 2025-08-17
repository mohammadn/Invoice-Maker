//
//  InvoiceView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/04/2025.
//

import SwiftUI

struct InvoiceView: View {
    @State var isEditing: Bool = false

    var invoice: InvoiceN

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

#Preview {
    InvoiceView(invoice: InvoiceN.sampleData[0])
        .modelContainer(previewContainer)
}
