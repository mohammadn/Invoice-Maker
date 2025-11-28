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
    @Query private var products: [Product]
    @State private var showProductFormView: Bool = false
    @State private var selectedProducts: Set<Product> = []

    @Binding var items: [ItemDetails]

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
                        Text(product.name ?? "-")
                            .tag(product)
                    }
                }
            }
            .navigationTitle("انتخاب محصول")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("تا‫ئید‬") {
                        updateItems(with: selectedProducts)

                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
        }
        .onAppear {
            let itemProductIds = Set(items.map { $0.productId })
            selectedProducts = Set(products.filter { itemProductIds.contains($0.id) })
        }
        .sheet(isPresented: $showProductFormView) {
            NavigationStack {
                ProductFormView()
            }
        }
    }

    func updateItems(with selectedProducts: Set<Product>) {
        let itemProductIds = Set(items.map { $0.productId })

        selectedProducts.forEach { product in
            if !itemProductIds.contains(product.id) {
                let item = ItemDetails(from: product, quantity: 1)

                items.append(item)
            }
        }

        items = items.filter { item in
            selectedProducts.contains(where: { $0.id == item.productId })
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var items: [ItemDetails] = []
        
        InvoiceProductSelection(items: $items)
            .modelContainer(previewContainer)
            .environment(\.layoutDirection, .rightToLeft)
    }
#endif
