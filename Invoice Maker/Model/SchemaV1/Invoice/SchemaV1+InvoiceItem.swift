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
        var productId: UUID = UUID()
        var productCode: Int?
        var productName: String?
        var productPrice: Decimal?
        var productCurrency: Currency?
        var productDetails: String?
        var quantity: Decimal?
        var invoice: SchemaV1.Invoice?

        var total: Decimal { (productPrice ?? 0) * (quantity ?? 0) }

        var product: SchemaV1.Product {
            Product(id: productId, code: productCode, name: productName, price: productPrice, currency: productCurrency, details: productDetails)
        }

        init(productId: UUID = UUID(),
             productCode: Int?,
             productName: String?,
             productPrice: Decimal?,
             productCurrency: Currency?,
             productDetails: String?,
             quantity: Decimal?,
             invoice: SchemaV1.Invoice? = nil
        ) {
            self.productId = productId
            self.productCode = productCode
            self.productName = productName
            self.productPrice = productPrice
            self.productCurrency = productCurrency
            self.productDetails = productDetails
            self.quantity = quantity
            self.invoice = invoice
        }

        convenience init(from item: ItemDetailsV1) {
            self.init(productId: item.productId,
                      productCode: item.productCode,
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
        return productPrice(in: targetCurrency) * (quantity ?? 0)
    }

    func productPrice(in targetCurrency: Currency) -> Decimal {
        switch (productCurrency, targetCurrency) {
        case (.IRR_Toman, .IRR):
            return (productPrice ?? 0) * 10
        case (.IRR, .IRR_Toman):
            return ((productPrice ?? 0) / 10).rounded()
        default:
            return (productPrice ?? 0)
        }
    }
}
