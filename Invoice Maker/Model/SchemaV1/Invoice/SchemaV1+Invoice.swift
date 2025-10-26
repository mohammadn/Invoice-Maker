//
//  SchemaV1+Invoice.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class Invoice: Identifiable {
        var id: UUID = UUID()
        var number: String?
        var type: InvoiceType?
        var currency: Currency?
        var date: Date?
        var dueDate: Date?
        var vat: Decimal?
        var discount: Decimal?
        var note: String?
        var status: Status?
        var options: [Option]?
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceItem.invoice) var items: [SchemaV1.InvoiceItem]?
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceCustomer.invoice) var customer: SchemaV1.InvoiceCustomer?
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceBusiness.invoice) var business: SchemaV1.InvoiceBusiness?
        var createdDate: Date = Date.now

        var isInvalid: Bool {
            number?.isEmpty == nil || customer?.id == nil || (items ?? []).isEmpty
        }

        var total: Decimal {
            let total: Decimal = (items ?? []).reduce(0) { result, item in result + item.total(in: currency ?? .IRR) }

            return total.rounded()
        }

        var discountAmount: Decimal {
            return (total * (discount ?? 0)).rounded()
        }

        var totalWithDiscount: Decimal {
            return (total - discountAmount).rounded()
        }

        var vatAmount: Decimal {
            return (totalWithDiscount * (vat ?? 0)).rounded()
        }

        var totalWithVAT: Decimal {
            return (totalWithDiscount + vatAmount).rounded()
        }

        var getCustomer: SchemaV1.Customer? {
            guard let customerId = customer?.id else { return nil }

            return SchemaV1.Customer(id: customerId,
                                     name: customer?.name,
                                     phone: customer?.phone,
                                     email: customer?.email,
                                     address: customer?.address,
                                     details: customer?.details
            )
        }

        var getBusiness: SchemaV1.Business? {
            guard let businessName = business?.name, let businessPhone = business?.phone else { return nil }

            return SchemaV1.Business(name: businessName,
                                     phone: businessPhone,
                                     email: business?.email,
                                     website: business?.website,
                                     address: business?.address
            )
        }

        init(number: String?,
             type: InvoiceType?,
             currency: Currency?,
             date: Date?,
             dueDate: Date?,
             vat: Decimal?,
             discount: Decimal?,
             note: String?,
             status: Status?,
             options: [Option]?,
             items: [SchemaV1.InvoiceItem]?,
             customer: SchemaV1.InvoiceCustomer?,
             business: SchemaV1.InvoiceBusiness?
        ) {
            self.number = number
            self.type = type
            self.currency = currency
            self.date = date
            self.dueDate = dueDate
            self.vat = vat
            self.discount = discount
            self.note = note
            self.status = status
            self.options = options
            self.items = items
            self.customer = customer
            self.business = business
        }

        convenience init(from invoiceDetails: InvoiceDetailsV1, customer: SchemaV1.InvoiceCustomer? = nil, business: SchemaV1.InvoiceBusiness) {
            self.init(number: invoiceDetails.number,
                      type: invoiceDetails.type,
                      currency: invoiceDetails.currency,
                      date: invoiceDetails.date,
                      dueDate: invoiceDetails.dueDate,
                      vat: invoiceDetails.vat,
                      discount: invoiceDetails.discount,
                      note: invoiceDetails.note,
                      status: invoiceDetails.status,
                      options: invoiceDetails.options,
                      items: [],
                      customer: customer,
                      business: business
            )
        }
    }
}

extension SchemaV1.Invoice {
    func update(with invoiceDetails: InvoiceDetailsV1) {
        number = invoiceDetails.number
        type = invoiceDetails.type
        currency = invoiceDetails.currency
        date = invoiceDetails.date
        dueDate = invoiceDetails.dueDate
        vat = invoiceDetails.vat ?? 0
        discount = invoiceDetails.discount ?? 0
        note = invoiceDetails.note
        status = invoiceDetails.status
        options = invoiceDetails.options
    }
}

extension SchemaV1.Invoice: Equatable {
    static func == (lhs: SchemaV1.Invoice, rhs: SchemaV1.Invoice) -> Bool {
        lhs.id == rhs.id &&
            lhs.number == rhs.number &&
            lhs.type == rhs.type &&
            lhs.currency == rhs.currency &&
            lhs.date == rhs.date &&
            lhs.dueDate == rhs.dueDate &&
            lhs.vat == rhs.vat &&
            lhs.discount == rhs.discount &&
            lhs.note == rhs.note &&
            lhs.status == rhs.status &&
            lhs.options == rhs.options &&
            lhs.items == rhs.items &&
            lhs.customer?.id == rhs.customer?.id &&
            lhs.business?.id == rhs.business?.id
    }
}

extension SchemaV1.Invoice: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
