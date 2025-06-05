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
    var productCurrency: String
    var productDetails: String?
    var quantity: Int
    var invoice: StandaloneInvoice?

    var product: VersionedProduct {
        VersionedProduct(code: productCode, name: productName, price: productPrice, currency: productCurrency, details: productDetails)
    }

    init(productCode: Int, productName: String, productPrice: Float, productCurrency: String, productDetails: String? = nil, quantity: Int = 1, invoice: StandaloneInvoice? = nil) {
        self.productCode = productCode
        self.productName = productName
        self.productPrice = productPrice
        self.productCurrency = productCurrency
        self.productDetails = productDetails
        self.quantity = quantity
        self.invoice = invoice
    }

    convenience init(from item: Item) {
        self.init(productCode: item.product.code,
                  productName: item.product.name,
                  productPrice: item.product.price,
                  productCurrency: "IRR",
                  productDetails: item.product.details,
                  quantity: item.quantity)
    }

    convenience init(from item: StandaloneItemDetails, invoice: StandaloneInvoice) {
        self.init(productCode: item.productCode,
                  productName: item.productName,
                  productPrice: item.productPrice,
                  productCurrency: item.productCurrency,
                  productDetails: item.productDetails,
                  quantity: item.quantity,
                  invoice: invoice)
    }
}

extension StandaloneItem {
    func update(with itemDetails: StandaloneItemDetails) {
        quantity = itemDetails.quantity
    }

    func update(with product: VersionedProduct) {
        productCode = product.code
        productName = product.name
        productPrice = product.price
        productCurrency = product.currency
        productDetails = product.details
    }
}
