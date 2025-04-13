//
//  Item.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData

@Model
class StandaloneItem {
    @Attribute(.unique) var productCode: Int
    var productName: String
    var productDetails: String?
    var productPrice: Float
    var quantity: Int
    var invoice: StandaloneInvoice?

    init(productCode: Int, productName: String, productDetails: String? = nil, productPrice: Float, quantity: Int = 1, invoice: StandaloneInvoice? = nil) {
        self.productCode = productCode
        self.productName = productName
        self.productDetails = productDetails
        self.productPrice = productPrice
        self.quantity = quantity
        self.invoice = invoice
    }

    convenience init(from item: Item) {
        self.init(productCode: item.product.code,
                  productName: item.product.name,
                  productDetails: item.product.details,
                  productPrice: item.product.price,
                  quantity: item.quantity)
    }

    convenience init(from item: StandaloneItemDetails) {
        self.init(productCode: item.productCode,
                  productName: item.productName,
                  productDetails: item.productDetails,
                  productPrice: item.productPrice,
                  quantity: item.quantity)
    }
}
