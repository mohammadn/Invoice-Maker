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
        NavigationSplitView {
            List(selection: $selectedProduct) {
                ForEach(filteredProducts) { product in
                    NavigationLink(value: product) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(product.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)

                                Spacer()

                                Text(product.price.formatted(.currency(code: "IRR")).toPersian())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }

                            Text(product.details?.isEmpty == false ? product.details! : "-").font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
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
                NavigationStack {
                    ProductFormView()
                }
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
        } detail: {
            if let product = selectedProduct {
                ProductView(product: product)
            } else {
                Text(".یک محصول را انتخاب کنید")
                    .font(.title)
                    .foregroundStyle(.secondary)
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
