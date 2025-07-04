//
//  InvoiceSchemaV1+Item.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension InvoiceSchemaV1 {
    @Model
    class VersionedItem {
        var productCode: Int
        var productName: String
        var productPrice: Decimal
        var productCurrency: Currency
        var productDetails: String?
        var quantity: Int
        var invoice: VersionedInvoice?

        var total: Decimal { productPrice * Decimal(quantity) }

        var product: VersionedProduct {
            VersionedProduct(code: productCode, name: productName, price: productPrice, currency: productCurrency, details: productDetails)
        }

        init(productCode: Int, productName: String, productPrice: Decimal, productCurrency: Currency, productDetails: String? = nil, quantity: Int = 1, invoice: VersionedInvoice? = nil) {
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
                      productPrice: Decimal(Double(item.product.price)),
                      productCurrency: .IRR,
                      productDetails: item.product.details,
                      quantity: item.quantity)
        }

        convenience init(from item: ItemDetails) {
            self.init(productCode: item.productCode,
                      productName: item.productName,
                      productPrice: item.productPrice,
                      productCurrency: item.productCurrency,
                      productDetails: item.productDetails,
                      quantity: item.quantity)
        }
    }
}

extension InvoiceSchemaV1.VersionedItem {
    func update(with itemDetails: ItemDetails) {
        quantity = itemDetails.quantity
    }

    func update(with product: VersionedProduct) {
        productCode = product.code
        productName = product.name
        productPrice = product.price
        productCurrency = product.currency
        productDetails = product.details
    }

    func total(in targetCurrency: Currency) -> Decimal {
        return productPrice(in: targetCurrency) * Decimal(quantity)
    }

    func productPrice(in targetCurrency: Currency) -> Decimal {
        switch (productCurrency, targetCurrency) {
        case (.IRR_Toman, .IRR):
            return productPrice * 10
        case (.IRR, .IRR_Toman):
            return (productPrice / 10).rounded()
        default:
            return productPrice
        }
    }
}
