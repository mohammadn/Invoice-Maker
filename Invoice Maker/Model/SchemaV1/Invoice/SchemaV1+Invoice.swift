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
    class Invoice {
        var number: String
        var type: InvoiceType
        var currency: Currency
        var date: Date
        var dueDate: Date
        var vat: Decimal
        var discount: Decimal
        var note: String
        var status: Status
        var options: [Options]
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceItem.invoice) var items: [SchemaV1.InvoiceItem]
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceCustomer.invoice) var customer: SchemaV1.InvoiceCustomer?
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.InvoiceBusiness.invoice) var business: SchemaV1.InvoiceBusiness?
        var createdDate: Date = Date.now

        var isInvalid: Bool {
            number.isEmpty || customer?.id == nil || items.isEmpty
        }

        var total: Decimal {
            let total: Decimal = items.reduce(0) { result, item in
                let itemTotal = Decimal(item.quantity) * item.productPrice
                // Convert item currency to match invoice currency
                switch (item.productCurrency, currency) {
                case (.IRR_Toman, .IRR):
                    return result + (itemTotal * 10)
                case (.IRR, .IRR_Toman):
                    return result + (itemTotal / 10)
                default:
                    return result + itemTotal
                }
            }

            return total.rounded()
        }

        var discountAmount: Decimal {
            return (total * (discount / 100)).rounded()
        }

        var totalWithDiscount: Decimal {
            return (total - discountAmount).rounded()
        }

        var vatAmount: Decimal {
            return (totalWithDiscount * (vat / 100)).rounded()
        }

        var totalWithVAT: Decimal {
            return (totalWithDiscount + vatAmount).rounded()
        }

        var getCustomer: SchemaV1.Customer? {
            guard let customerId = customer?.id, let customerName = customer?.name else { return nil }

            return SchemaV1.Customer(id: customerId, name: customerName, address: customer?.address, details: customer?.details, phone: customer?.phone, email: customer?.email)
        }

        var getBusiness: SchemaV1.Business? {
            guard let businessName = business?.name, let businessPhone = business?.phone else { return nil }

            return SchemaV1.Business(name: businessName, phone: businessPhone, email: business?.email, website: business?.website, address: business?.address)
        }

        init(number: String,
             type: InvoiceType,
             currency: Currency,
             date: Date,
             dueDate: Date,
             vat: Decimal,
             discount: Decimal,
             note: String,
             status: Status,
             options: [Options],
             items: [SchemaV1.InvoiceItem],
             customer: SchemaV1.InvoiceCustomer?,
             business: SchemaV1.InvoiceBusiness?,
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
                      vat: invoiceDetails.vat ?? 0,
                      discount: invoiceDetails.discount ?? 0,
                      note: invoiceDetails.note,
                      status: invoiceDetails.status,
                      options: invoiceDetails.options,
                      items: [],
                      customer: customer,
                      business: business)
        }
    }
}

extension SchemaV1.Invoice {
    enum InvoiceType: String, Codable, CaseIterable {
        case sale, proforma

        var label: String {
            switch self {
            case .sale: "فاکتور فروش"
            case .proforma: "پیش فاکتور فروش"
            }
        }

        init(from value: Invoice.InvoiceType) {
            switch value {
            case .sale:
                self = .sale
            case .proforma:
                self = .proforma
            }
        }
    }
}

extension SchemaV1.Invoice {
    enum Status: String, Codable, CaseIterable {
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

extension SchemaV1.Invoice {
    enum Options: String, Codable, CaseIterable {
        case dueDate

        var label: String {
            switch self {
            case .dueDate: "تاریخ سررسید"
            }
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
