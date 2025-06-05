//
//  Invoice.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import Foundation
import SwiftData

@Model
class StandaloneInvoice {
    var number: String
    var type: Invoice.InvoiceType
    var currency: String
    var date: Date
    var note: String
    var status: Status
    @Relationship(deleteRule: .cascade, inverse: \StandaloneItem.invoice) var items: [StandaloneItem]
    var createdDate: Date = Date.now

    var customerId: UUID?
    var customerName: String?
    var customerPhone: String?
    var customerEmail: String?
    var customerAddress: String?
    var customerDetails: String?

    var businessName: String
    var businessPhone: String
    var businessEmail: String?
    var businessWebsite: String?
    var businessAddress: String?

    var isInvalid: Bool {
        number.isEmpty || customerId == nil || items.isEmpty
    }

    var total: Decimal {
        items.reduce(0) { $0 + (Decimal($1.quantity) * $1.productPrice) }
    }

    var customer: Customer? {
        guard let customerId, let customerName else { return nil }

        return Customer(id: customerId, name: customerName, address: customerAddress, details: customerDetails, phone: customerPhone, email: customerEmail)
    }

    var business: Business {
        Business(name: businessName, address: businessAddress, phone: businessPhone, email: businessEmail, website: businessWebsite)
    }

    init(number: String,
         type: Invoice.InvoiceType,
         currency: String,
         date: Date,
         note: String,
         status: Status,
         items: [StandaloneItem],
         customerId: UUID?,
         customerName: String?,
         customerPhone: String?,
         customerEmail: String?,
         customerAddress: String?,
         customerDetails: String?,
         businessName: String,
         businessPhone: String,
         businessEmail: String?,
         businessWebsite: String?,
         businessAddress: String?,
    ) {
        self.number = number
        self.type = type
        self.currency = currency
        self.date = date
        self.note = note
        self.status = status
        self.items = items
        self.customerId = customerId
        self.customerName = customerName
        self.customerPhone = customerPhone
        self.customerEmail = customerEmail
        self.customerAddress = customerAddress
        self.customerDetails = customerDetails
        self.businessName = businessName
        self.businessPhone = businessPhone
        self.businessEmail = businessEmail
        self.businessWebsite = businessWebsite
        self.businessAddress = businessAddress
    }

    convenience init(from invoice: Invoice, business: Business, items: [StandaloneItem], customer: Customer? = nil) {
        self.init(number: invoice.number,
                  type: invoice.type,
                  currency: "IRR",
                  date: invoice.date,
                  note: invoice.note,
                  status: .pending,
                  items: items,
                  customerId: customer?.id,
                  customerName: customer?.name,
                  customerPhone: customer?.phone,
                  customerEmail: customer?.email,
                  customerAddress: customer?.address,
                  customerDetails: customer?.details,
                  businessName: business.name,
                  businessPhone: business.phone,
                  businessEmail: business.email,
                  businessWebsite: business.website,
                  businessAddress: business.address)
    }

    convenience init(from invoiceDetails: StandaloneInvoiceDetails) {
        self.init(number: invoiceDetails.number,
                  type: invoiceDetails.type,
                  currency: invoiceDetails.currency,
                  date: invoiceDetails.date,
                  note: invoiceDetails.note,
                  status: invoiceDetails.status,
                  items: [],
                  customerId: invoiceDetails.customerId,
                  customerName: invoiceDetails.customerName,
                  customerPhone: invoiceDetails.customerPhone,
                  customerEmail: invoiceDetails.customerEmail,
                  customerAddress: invoiceDetails.customerAddress,
                  customerDetails: invoiceDetails.customerDetails,
                  businessName: invoiceDetails.businessName,
                  businessPhone: invoiceDetails.businessPhone,
                  businessEmail: invoiceDetails.businessEmail,
                  businessWebsite: invoiceDetails.businessWebsite,
                  businessAddress: invoiceDetails.businessAddress)
    }
}

extension StandaloneInvoice {
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

extension StandaloneInvoice {
    func update(with invoiceDetails: StandaloneInvoiceDetails) {
        number = invoiceDetails.number
        type = invoiceDetails.type
        currency = invoiceDetails.currency
        date = invoiceDetails.date
        note = invoiceDetails.note
        status = invoiceDetails.status
        customerId = invoiceDetails.customerId
        customerName = invoiceDetails.customerName
        customerPhone = invoiceDetails.customerPhone
        customerEmail = invoiceDetails.customerEmail
        customerAddress = invoiceDetails.customerAddress
        customerDetails = invoiceDetails.customerDetails
        businessName = invoiceDetails.businessName
        businessPhone = invoiceDetails.businessPhone
        businessEmail = invoiceDetails.businessEmail
        businessWebsite = invoiceDetails.businessWebsite
        businessAddress = invoiceDetails.businessAddress
    }

    func updateCustomer(with customer: Customer) {
        customerId = customer.id
        customerName = customer.name
        customerPhone = customer.phone
        customerEmail = customer.email
        customerAddress = customer.address
        customerDetails = customer.details
    }

    func updateBusiness(with business: Business) {
        businessName = business.name
        businessPhone = business.phone
        businessEmail = business.email
        businessWebsite = business.website
        businessAddress = business.address
    }
}
