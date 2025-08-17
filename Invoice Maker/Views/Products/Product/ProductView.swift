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
                ProductDetailView(product: product, isEditing: $isEditing)
            }
        }
        .animation(.default, value: isEditing)
    }
}

#Preview {
    ProductView(product: Product.sampleData.first!)
        .modelContainer(previewContainer)
}
