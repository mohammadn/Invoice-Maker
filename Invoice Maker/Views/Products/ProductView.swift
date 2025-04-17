//
//  ProductView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/04/2025.
//

import SwiftUI

struct ProductView: View {
    @State var isEditing: Bool = false

    var product: Product

    var body: some View {
        NavigationStack {
            if isEditing {
                ProductFormView(product: product) {
                    isEditing.toggle()
                }
            } else {
                List {
                    Section {
                        LabeledContent("کد", value: product.code, format: .number)
                    }

                    Section {
                        LabeledContent("نام", value: product.name)
                        LabeledContent("جزئیات", value: product.details?.isEmpty == false ? product.details! : "-")
                    }

                    Section {
                        LabeledContent("قیمت", value: product.price, format: .currency(code: "IRR"))
                    }
                }
                .navigationTitle(product.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                        Button("ویرایش") {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
        .animation(.default, value: isEditing)
    }
}

// #Preview {
//    ProductView(product: Product.sampleData[0])
// }
