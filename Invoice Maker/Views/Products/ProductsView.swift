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
    @State private var isProductsAddViewPresented: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    LabeledContent {
                        Text("\(product.price, specifier: "%.2f")")

                        Button {
                            print(1)
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.title3)
                        }
                    } label: {
                        Text(product.name)
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .navigationTitle("محصولات")
            .toolbar {
                ToolbarItemGroup {
                    Button("اضافه", systemImage: "plus") {
                        isProductsAddViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isProductsAddViewPresented) {
                ProductsAddView()
                    .environment(\.layoutDirection, .rightToLeft)
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
