//
//  Item.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData

@Model
class StandaloneItem {
    var productCode: Int
    var productName: String
    var productPrice: Float
    var productDetails: String?
    var quantity: Int
    var invoice: StandaloneInvoice?

    var product: Product {
        Product(code: productCode, name: productName, details: productDetails, price: productPrice)
    }

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

    convenience init(from item: StandaloneItemDetails, invoice: StandaloneInvoice) {
        self.init(productCode: item.productCode,
                  productName: item.productName,
                  productDetails: item.productDetails,
                  productPrice: item.productPrice,
                  quantity: item.quantity,
                  invoice: invoice)
    }
}

extension StandaloneItem {
    func update(with itemDetails: StandaloneItemDetails) {
        quantity = itemDetails.quantity
    }

    func update(with product: Product) {
        productCode = product.code
        productName = product.name
        productPrice = product.price
        productDetails = product.details
    }
}
