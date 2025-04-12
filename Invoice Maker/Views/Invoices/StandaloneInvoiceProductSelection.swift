//
//  InvoiceProductSelection.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/02/2024.
//

import SwiftData
import SwiftUI

struct StandaloneInvoiceProductSelection: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Product.name) private var products: [Product]
    @State private var showProductFormView: Bool = false
    @State private var selectedProducts: Set<Product> = []

    @Binding var items: [StandaloneItemDetails]

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
            let itemProductCodes = Set(items.map { $0.productCode })
            selectedProducts = Set(products.filter { itemProductCodes.contains($0.code) })
        }
        .sheet(isPresented: $showProductFormView) {
            ProductFormView()
        }
    }

    func updateItems(with selectedProducts: Set<Product>) {
        let itemProductCodes = Set(items.map { $0.productCode })

        selectedProducts.forEach { product in
            if !itemProductCodes.contains(product.code) {
                let item = StandaloneItemDetails(from: product, quantity: 1)

                items.append(item)
            }
        }

        items = items.filter { item in
            selectedProducts.contains(where: { $0.code == item.productCode })
        }
    }
}

// #Preview {
//    InvoiceProductSelection(items: .constant([]))
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
