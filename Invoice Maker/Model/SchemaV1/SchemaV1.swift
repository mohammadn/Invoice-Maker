//
//  SchemaV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 10/08/2025.
//

import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [SchemaV1.Business.self,
         SchemaV1.Invoice.self,
         SchemaV1.InvoiceItem.self,
         SchemaV1.InvoiceCustomer.self,
         SchemaV1.InvoiceBusiness.self,
         SchemaV1.Product.self,
         SchemaV1.Customer.self]
    }
}
