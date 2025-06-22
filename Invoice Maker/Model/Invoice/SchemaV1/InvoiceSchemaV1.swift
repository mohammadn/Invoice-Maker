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
        var currency: String
        var date: Date
        var note: String
        var status: Status
        @Relationship(deleteRule: .cascade, inverse: \VersionedItem.invoice) var items: [VersionedItem]
        @Relationship(deleteRule: .cascade, inverse: \InvoiceCustomer.invoice) var customer: InvoiceCustomer?
        @Relationship(deleteRule: .cascade, inverse: \InvoiceBusiness.invoice) var business: InvoiceBusiness?
        var createdDate: Date = Date.now

        var isInvalid: Bool {
            number.isEmpty || customer?.id == nil || items.isEmpty
        }

        var total: Decimal {
            items.reduce(0) { $0 + (Decimal($1.quantity) * $1.productPrice) }
        }

        var getCustomer: Customer? {
            guard let customerId = customer?.id, let customerName = customer?.name else { return nil }

            return Customer(id: customerId, name: customerName, address: customer?.address, details: customer?.details, phone: customer?.phone, email: customer?.email)
        }

        var getBusiness: Business? {
            guard let businessName = business?.name, let businessPhone = business?.phone else { return nil }

            return Business(name: businessName, phone: businessPhone, email: business?.email, website: business?.website, address: business?.address)
        }

        init(number: String,
             type: Invoice.InvoiceType,
             currency: String,
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

        convenience init(from invoice: Invoice, items: [VersionedItem], customer: InvoiceCustomer? = nil, business: InvoiceBusiness) {
            self.init(number: invoice.number,
                      type: invoice.type,
                      currency: "IRR",
                      date: invoice.date,
                      note: invoice.note,
                      status: .pending,
                      items: items,
                      customer: customer,
                      business: business)
        }

        convenience init(from invoiceDetails: InvoiceDetails, customer: InvoiceCustomer? = nil, business: InvoiceBusiness) {
            self.init(number: invoiceDetails.number,
                      type: invoiceDetails.type,
                      currency: invoiceDetails.currency,
                      date: invoiceDetails.date,
                      note: invoiceDetails.note,
                      status: invoiceDetails.status,
                      items: [],
                      customer: customer,
                      business: business)
        }
    }
}

extension InvoiceSchemaV1.VersionedInvoice {
    enum Status: Codable, CaseIterable {
        case invalid, draft, expired, pending, cancelled, paid

        var label: String {
            switch self {
            case .invalid: "نامعتبر"
            case .draft: "پیش نویس"
            case .expired: "منقضی"
            case .pending: "آماده پرداخت"
            case .cancelled: "لغو شده"
            case .paid: "پرداخت شده"
            }
        }
    }
}

extension InvoiceSchemaV1.VersionedInvoice {
    func update(with invoiceDetails: InvoiceDetails) {
        number = invoiceDetails.number
        type = invoiceDetails.type
        currency = invoiceDetails.currency
        date = invoiceDetails.date
        note = invoiceDetails.note
        status = invoiceDetails.status
    }
}
