//
//  InvoicesView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import SwiftData
import SwiftUI

struct InvoicesView: View {
    @Query(sort: \Invoice.createdDate) private var invoices: [Invoice]
    @State private var showInvoiceFormView: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(invoices) { invoice in
                    Text(invoice.number)
                }
            }
            .navigationBarTitle("فاکتورها")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("اضافه", systemImage: "plus") {
                        showInvoiceFormView.toggle()
                    }
                }
            }
            .sheet(isPresented: $showInvoiceFormView) {
                InvoiceFormView()
                    .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
}

#Preview {
    InvoicesView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
