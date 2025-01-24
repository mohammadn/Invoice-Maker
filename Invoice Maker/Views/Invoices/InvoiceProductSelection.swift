//
//  InvoiceProductSelection.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/02/2024.
//

import SwiftData
import SwiftUI

struct InvoiceProductSelection: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Product.name) private var products: [Product]
    @State private var showProductFormView: Bool = false
    @State private var selectedProducts: Set<Product> = []

    @Binding var items: [(product: Product, quantity: Int)]

    var body: some View {
        NavigationStack {
            List(selection: $selectedProducts) {
                Section {
                    Button("افزودن محصول", systemImage: "plus") {
                        showProductFormView.toggle()
                    }
                }

                Section {
                    ForEach(products) { product in
                        Text(product.name)
                            .tag(product)
                    }
                }
            }
            .navigationBarTitle("انتخاب محصول")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("تا‫ئید‬") {
                        updateItems(with: selectedProducts)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
        }
        .onAppear {
            selectedProducts = Set(items.map { $0.product })
        }
        .sheet(isPresented: $showProductFormView) {
            ProductFormView()
        }
    }

    func updateItems(with selectedProducts: Set<Product>) {
        selectedProducts.forEach { product in
            if !items.contains(where: { $0.product == product }) {
                let newItem = (product, 1)
                items.append(newItem)
            }
        }

        items = items.filter { item in
            selectedProducts.contains(where: { $0 == item.product })
        }
    }
}

// #Preview {
//    InvoiceProductSelection(items: .constant([]))
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
