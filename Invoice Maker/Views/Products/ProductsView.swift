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
    @State private var isProductFormViewPresented: Bool = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        LabeledContent {
                            HStack {
                                Text("\(product.price)")
                                
                                Button {
                                    selectedProduct = product
                                } label: {
                                    Image(systemName: "info.circle")
                                        .font(.title3)
                                }
                            }
                        } label: {
                            Text(product.name)
                        }
                        
                        Text(product.details ?? "-")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .navigationTitle("محصولات")
            .toolbar {
                ToolbarItemGroup {
                    Button("اضافه", systemImage: "plus") {
                        isProductFormViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isProductFormViewPresented) {
                ProductFormView()
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(item: $selectedProduct) { product in
                ProductFormView(product: product)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .overlay {
                if products.isEmpty {
                    ContentUnavailableView {
                        Label("محصولی یافت نشد", systemImage: "list.dash")
                    } description: {
                        Text("برای افزودن محصول جدید روی دکمه + کلیک کنید")
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

//#Preview {
//    ProductsView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
//}
