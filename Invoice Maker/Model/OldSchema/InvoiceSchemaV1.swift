//
//  InvoiceSchemaV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

enum InvoiceSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [InvoiceSchemaV1.VersionedInvoice.self, InvoiceSchemaV1.VersionedItem.self,
         InvoiceSchemaV1.InvoiceCustomer.self, InvoiceSchemaV1.InvoiceBusiness.self]
    }

    @Model
    class VersionedInvoice {
        var number: String
        var type: Invoice.InvoiceType
        var currency: Currency
        var date: Date
        var note: String
        var status: Status
        @Relationship(deleteRule: .cascade, inverse: \VersionedItem.invoice) var items: [VersionedItem]
        @Relationship(deleteRule: .cascade, inverse: \InvoiceCustomer.invoice) var customer: InvoiceCustomer?
        @Relationship(deleteRule: .cascade, inverse: \InvoiceBusiness.invoice) var business: InvoiceBusiness?
        var createdDate: Date = Date.now

        init(number: String,
             type: Invoice.InvoiceType,
             currency: Currency,
             date: Date,
             note: String,
             status: Status,
             items: [VersionedItem],
             customer: InvoiceCustomer?,
             business: InvoiceBusiness,
        ) {
            self.number = number
            self.type = type
            self.currency = currency
            self.date = date
            self.note = note
            self.status = status
            self.items = items
            self.customer = customer
            self.business = business
        }
    }
}

extension InvoiceSchemaV1.VersionedInvoice {
    enum Status: Codable, CaseIterable {
        case invalid, draft, expired, pending, cancelled, paid
    }
}
