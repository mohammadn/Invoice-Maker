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
    @State private var searchText: String = ""

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                $0.code.description.localizedCaseInsensitiveContains(searchText) ||
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    ($0.details?.localizedCaseInsensitiveContains(searchText) == true) ||
                    $0.price.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredProducts) { product in
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
                .onDelete(perform: delete)
            }
            .navigationTitle("محصولات")
            .searchable(text: $searchText, prompt: "جستجو")
            .toolbar {
                ToolbarItemGroup {
                    Button("اضافه", systemImage: "plus") {
                        isProductFormViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isProductFormViewPresented) {
                ProductFormView()
            }
            .sheet(item: $selectedProduct) { product in
                ProductFormView(product: product)
            }
            .overlay {
                if filteredProducts.isEmpty && searchText.isEmpty {
                    ContentUnavailableView {
                        Label("محصولی یافت نشد", systemImage: "list.dash")
                    } description: {
                        Text("برای افزودن محصول جدید روی دکمه + کلیک کنید")
                    }
                }

                if filteredProducts.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView {
                        Label("محصولی با این مشخصات یافت نشد", systemImage: "magnifyingglass")
                    } description: {
                        Text("برای جستجو، کد، نام، قیمت یا جزئیات محصول را وارد کنید")
                    }
                }
            }
        }
    }

    private func delete(at indexSet: IndexSet) {
        if searchText.isEmpty {
            indexSet.forEach { index in
                modelContext.delete(products[index])
            }
        } else {
            indexSet.forEach { index in
                let productToDelete = filteredProducts[index]

                if let product = products.first(where: { $0.id == productToDelete.id }) {
                    modelContext.delete(product)
                }
            }
        }
    }
}

// #Preview {
//    ProductsView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
