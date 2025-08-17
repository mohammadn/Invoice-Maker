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
    @State private var showProductFormView: Bool = false
    @State private var selectedProducts: Set<Product> = []
    @State private var searchText: String = ""
    @State private var editMode: EditMode = .inactive

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
            List(selection: $selectedProducts) {
                ForEach(filteredProducts, id: \.self) { product in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(product.name)
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Spacer()

                            Text(product.price, format: .currencyFormatter(code: product.currency))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .padding(.trailing, editMode.isEditing ? 0 : 20)
                        }
                        .background {
                            NavigationLink(value: product) { EmptyView() }
                                .opacity(editMode.isEditing ? 0 : 1)
                        }

                        Text(product.details?.isEmpty == false ? product.details! : "-").font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                    .swipeActions {
                        Button("حذف", role: .destructive) {
                            delete(product: product)
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("محصولات")
            .searchable(text: $searchText, prompt: "جستجو")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if editMode.isEditing {
                        Button("حذف") {
                            delete(products: selectedProducts)
                            editMode = .inactive
                        }
                        .disabled(selectedProducts.isEmpty)
                    } else {
                        Button("افزودن", systemImage: "plus") {
                            showProductFormView.toggle()
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(editMode.isEditing ? "پایان" : "ویرایش") {
                        withAnimation {
                            editMode = editMode.isEditing ? .inactive : .active
                            selectedProducts.removeAll()
                        }
                    }
                }
            }
            .sheet(isPresented: $showProductFormView) {
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
                        Text("برای جستجو، کد، نام، قیمت یا توضیحات محصول را وارد کنید")
                    }
                }
            }
        } detail: {
            switch selectedProducts.count {
            case 0:
                Text("یک محصول انتخاب کنید")
                    .font(.title)
            case 1:
                if let product = selectedProducts.first {
                    ProductView(product: product)
                }
            default:
                Text("\(selectedProducts.count) محصول انتخاب شده است")
                    .font(.title)
            }
        }
    }

    private func delete(product: Product) {
        modelContext.delete(product)
    }

    private func delete(products: Set<Product>) {
        for product in products {
            modelContext.delete(product)
        }
    }
}

#Preview {
    ProductsView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
