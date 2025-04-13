//
//  ProductView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/04/2025.
//

import SwiftUI

struct ProductView: View {
    @State var isEditingProduct: Bool = false

    var product: Product

    var body: some View {
        NavigationStack {
            if isEditingProduct {
                ProductFormView(product: product) {
                    isEditingProduct.toggle()
                }
            } else {
                List {
                    Section {
                        LabeledContent("کد", value: product.code.description.toPersian())
                    }

                    Section {
                        LabeledContent("نام", value: product.name)
                        LabeledContent("جزئیات", value: product.details?.isEmpty == false ? product.details! : "-")
                    }

                    Section {
                        LabeledContent("قیمت", value: product.price.formatted(.currency(code: "IRR")).toPersian())
                    }
                }
                .navigationTitle(product.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                        Button("ویرایش") {
                            isEditingProduct.toggle()
                        }
                    }
                }
            }
        }
        .animation(.default, value: isEditingProduct)
    }
}

// #Preview {
//    ProductView(product: Product.sampleData[0])
// }
