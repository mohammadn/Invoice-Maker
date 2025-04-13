//
//  Item.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import Foundation
import SwiftData

@Observable
class StandaloneItemDetails: Identifiable {
    var id: UUID = UUID()
    var productCode: Int
    var productName: String
    var productDetails: String?
    var productPrice: Int
    var quantity: Int

    init(productCode: Int, productName: String, productDetails: String? = nil, productPrice: Int, quantity: Int = 1) {
        self.productCode = productCode
        self.productName = productName
        self.productDetails = productDetails
        self.productPrice = productPrice
        self.quantity = quantity
    }

    convenience init(from item: StandaloneItem) {
        self.init(productCode: item.productCode,
                  productName: item.productName,
                  productDetails: item.productDetails,
                  productPrice: item.productPrice,
                  quantity: item.quantity)
    }

    convenience init(from product: Product, quantity: Int) {
        self.init(productCode: product.code,
                  productName: product.name,
                  productDetails: product.details,
                  productPrice: product.price,
                  quantity: quantity)
    }
}

extension StandaloneItemDetails: Equatable {
    static func == (lhs: StandaloneItemDetails, rhs: StandaloneItemDetails) -> Bool {
        lhs.productCode == rhs.productCode &&
            lhs.productName == rhs.productName &&
            lhs.productDetails == rhs.productDetails &&
            lhs.productPrice == rhs.productPrice &&
            lhs.quantity == rhs.quantity
    }
}

extension StandaloneItemDetails: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(productCode)
        hasher.combine(productName)
        hasher.combine(productDetails)
        hasher.combine(productPrice)
        hasher.combine(quantity)
    }
}
