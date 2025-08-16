//
//  SchemaV1+InvoiceItem.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class InvoiceItem {
        var productCode: Int
        var productName: String
        var productPrice: Decimal
        var productCurrency: Currency
        var productDetails: String?
        var quantity: Int
        var invoice: SchemaV1.Invoice?

        var total: Decimal { productPrice * Decimal(quantity) }

        var product: SchemaV1.Product {
            Product(code: productCode, name: productName, price: productPrice, currency: productCurrency, details: productDetails)
        }

        init(productCode: Int,
             productName: String,
             productPrice: Decimal,
             productCurrency: Currency,
             productDetails: String? = nil,
             quantity: Int = 1,
             invoice: SchemaV1.Invoice? = nil
        ) {
            self.productCode = productCode
            self.productName = productName
            self.productPrice = productPrice
            self.productCurrency = productCurrency
            self.productDetails = productDetails
            self.quantity = quantity
            self.invoice = invoice
        }

        convenience init(from item: ItemDetailsV1) {
            self.init(productCode: item.productCode,
                      productName: item.productName,
                      productPrice: item.productPrice,
                      productCurrency: item.productCurrency,
                      productDetails: item.productDetails,
                      quantity: item.quantity
            )
        }

        convenience init(from item: SchemaV1.InvoiceItem) {
            self.init(productCode: item.productCode,
                      productName: item.productName,
                      productPrice: item.productPrice,
                      productCurrency: item.productCurrency,
                      productDetails: item.productDetails,
                      quantity: item.quantity
            )
        }
    }
}

extension SchemaV1.InvoiceItem {
    func update(with itemDetails: ItemDetailsV1) {
        quantity = itemDetails.quantity
    }

    func update(with product: SchemaV1.Product) {
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
