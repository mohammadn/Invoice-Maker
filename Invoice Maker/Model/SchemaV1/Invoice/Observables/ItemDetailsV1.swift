//
//  ItemDetailsV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import Foundation
import SwiftData

@Observable
class ItemDetailsV1: Identifiable {
    var id: UUID = UUID()
    var productId: UUID
    var productCode: Int
    var productName: String
    var productPrice: Decimal
    var productCurrency: Currency
    var productDetails: String?
    var quantity: Int

    init(productId: UUID,
         productCode: Int,
         productName: String,
         productPrice: Decimal,
         productCurrency: Currency,
         productDetails: String? = nil,
         quantity: Int = 1
    ) {
        self.productId = productId
        self.productCode = productCode
        self.productName = productName
        self.productPrice = productPrice
        self.productCurrency = productCurrency
        self.productDetails = productDetails
        self.quantity = quantity
    }

    convenience init(from item: SchemaV1.InvoiceItem) {
        self.init(
            productId: item.productId,
            productCode: item.productCode,
            productName: item.productName,
            productPrice: item.productPrice,
            productCurrency: item.productCurrency,
            productDetails: item.productDetails,
            quantity: item.quantity
        )
    }

    convenience init(from product: SchemaV1.Product, quantity: Int) {
        self.init(productId: product.id,
                  productCode: product.code,
                  productName: product.name,
                  productPrice: product.price,
                  productCurrency: product.currency,
                  productDetails: product.details,
                  quantity: quantity
        )
    }
}

extension ItemDetailsV1: Equatable {
    static func == (lhs: ItemDetailsV1, rhs: ItemDetailsV1) -> Bool {
        lhs.productId == rhs.productId &&
            lhs.productCode == rhs.productCode &&
            lhs.productName == rhs.productName &&
            lhs.productPrice == rhs.productPrice &&
            lhs.productCurrency == rhs.productCurrency &&
            lhs.productDetails == rhs.productDetails &&
            lhs.quantity == rhs.quantity
    }
}

extension ItemDetailsV1: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(productId)
        hasher.combine(productCode)
        hasher.combine(productName)
        hasher.combine(productPrice)
        hasher.combine(productCurrency)
        hasher.combine(productDetails)
        hasher.combine(quantity)
    }
}
