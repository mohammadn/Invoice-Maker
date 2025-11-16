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
    var quantity: Decimal

    init(productId: UUID,
         productCode: Int,
         productName: String,
         productPrice: Decimal,
         productCurrency: Currency,
         productDetails: String? = nil,
         quantity: Decimal = 1
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
            productCode: item.productCode ?? 0,
            productName: item.productName ?? "-",
            productPrice: item.productPrice ?? 0,
            productCurrency: item.productCurrency ?? .IRR,
            productDetails: item.productDetails,
            quantity: item.quantity ?? 1
        )
    }

    convenience init(from product: SchemaV1.Product, quantity: Decimal) {
        self.init(productId: product.id,
                  productCode: product.code ?? 0,
                  productName: product.name ?? "-",
                  productPrice: product.price ?? 0,
                  productCurrency: product.currency ?? .IRR,
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
