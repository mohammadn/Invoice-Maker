//
//  ProductSchemaV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation
import SwiftData

enum ProductSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [ProductSchemaV1.VersionedProduct.self]
    }

    @Model
    class VersionedProduct {
        @Attribute(.unique) var code: Int
        var name: String
        var price: Decimal
        var currency: Currency
        var details: String?
        var createdDate: Date = Date.now

        init(code: Int, name: String, price: Decimal, currency: Currency, details: String?) {
            self.code = code
            self.name = name
            self.price = price
            self.currency = currency
            self.details = details
        }
    }
}

extension ProductSchemaV1.VersionedProduct: Equatable {
    static func == (lhs: ProductSchemaV1.VersionedProduct, rhs: ProductSchemaV1.VersionedProduct) -> Bool {
        lhs.code == rhs.code &&
            lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.details == rhs.details
    }
}

extension ProductSchemaV1.VersionedProduct: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(currency)
        hasher.combine(details)
    }
}
