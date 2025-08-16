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

        init(productCode: Int, productName: String, productPrice: Decimal, productCurrency: Currency, productDetails: String? = nil, quantity: Int = 1, invoice: VersionedInvoice? = nil) {
            self.productCode = productCode
            self.productName = productName
            self.productPrice = productPrice
            self.productCurrency = productCurrency
            self.productDetails = productDetails
            self.quantity = quantity
            self.invoice = invoice
        }
    }
}
