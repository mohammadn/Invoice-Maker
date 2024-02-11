//
//  ProductsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct ProductsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Product.createdDate) private var products: [Product]

    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    NavigationLink(destination: Text(product.details)) {
                        HStack {
                            Text(product.name)
                            Spacer()
                            Text("\(product.price, specifier: "%.2f")")
                        }
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .navigationTitle("محصولات")
            .toolbar {
                ToolbarItemGroup {
                    EditButton()

                    Button("اضافه", systemImage: "plus") {
                    }
                }
            }
        }
    }

    private func deleteProduct(at indexSet: IndexSet) {
        indexSet.forEach { index in
            modelContext.delete(products[index])
        }
    }
}

#Preview {
    ProductsView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
