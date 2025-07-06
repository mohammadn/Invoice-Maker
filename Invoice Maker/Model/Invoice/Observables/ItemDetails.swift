//
//  ItemDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import Foundation
import SwiftData

@Observable
class ItemDetails: Identifiable {
    var id: UUID = UUID()
    var productCode: Int
    var productName: String
    var productPrice: Decimal
    var productCurrency: Currency
    var productDetails: String?
    var quantity: Int

    init(productCode: Int, productName: String, productPrice: Decimal, productCurrency: Currency, productDetails: String? = nil, quantity: Int = 1) {
        self.productCode = productCode
        self.productName = productName
        self.productPrice = productPrice
        self.productCurrency = productCurrency
        self.productDetails = productDetails
        self.quantity = quantity
    }

    convenience init(from item: VersionedItem) {
        self.init(productCode: item.productCode,
                  productName: item.productName,
                  productPrice: item.productPrice,
                  productCurrency: item.productCurrency,
                  productDetails: item.productDetails,
                  quantity: item.quantity)
    }

    convenience init(from product: VersionedProduct, quantity: Int) {
        self.init(productCode: product.code,
                  productName: product.name,
                  productPrice: product.price,
                  productCurrency: product.currency,
                  productDetails: product.details,
                  quantity: quantity)
    }
}

extension ItemDetails: Equatable {
    static func == (lhs: ItemDetails, rhs: ItemDetails) -> Bool {
        lhs.productCode == rhs.productCode &&
            lhs.productName == rhs.productName &&
            lhs.productPrice == rhs.productPrice &&
            lhs.productCurrency == rhs.productCurrency &&
            lhs.productDetails == rhs.productDetails &&
            lhs.quantity == rhs.quantity
    }
}

extension ItemDetails: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(productCode)
        hasher.combine(productName)
        hasher.combine(productPrice)
        hasher.combine(productCurrency)
        hasher.combine(productDetails)
        hasher.combine(quantity)
    }
}
