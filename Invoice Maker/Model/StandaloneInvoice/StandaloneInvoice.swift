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

    var total: Float {
        items.reduce(0) { $0 + (Float($1.quantity) * $1.productPrice) }
    }

    var customer: Customer? {
        guard let customerId, let customerName else { return nil }

        return Customer(id: customerId, name: customerName, address: customerAddress, details: customerDetails, phone: customerPhone, email: customerEmail)
    }

    var business: Business {
        Business(name: businessName, address: businessAddress, phone: businessPhone, email: businessEmail, website: businessWebsite)
    }

    init(number: String = "",
         customerId: UUID? = nil,
         customerName: String? = nil,
         customerAddress: String? = nil,
         customerDetails: String? = nil,
         customerPhone: String? = nil,
         customerEmail: String? = nil,
         businessName: String,
         businessPhone: String,
         businessAddress: String? = nil,
         businessEmail: String? = nil,
         businessWebsite: String? = nil,
         date: Date = .now,
         note: String = "",
         type: Invoice.InvoiceType = .sale,
         items: [StandaloneItem] = [],
         status: Status = .pending) {
        self.number = number
        self.customerId = customerId
        self.customerName = customerName
        self.customerAddress = customerAddress
        self.customerDetails = customerDetails
        self.customerPhone = customerPhone
        self.customerEmail = customerEmail
        self.businessName = businessName
        self.businessPhone = businessPhone
        self.businessAddress = businessAddress
        self.businessEmail = businessEmail
        self.businessWebsite = businessWebsite
        self.date = date
        self.note = note
        self.type = type
        self.items = items
        self.status = status
    }

    convenience init(from invoice: Invoice, business: Business, items: [StandaloneItem], customer: Customer? = nil) {
        self.init(number: invoice.number,
                  customerId: customer?.id,
                  customerName: customer?.name,
                  customerAddress: customer?.address,
                  customerDetails: customer?.details,
                  customerPhone: customer?.phone,
                  customerEmail: customer?.email,
                  businessName: business.name,
                  businessPhone: business.phone,
                  businessAddress: business.address,
                  businessEmail: business.email,
                  businessWebsite: business.website,
                  date: invoice.date,
                  note: invoice.note,
                  type: invoice.type,
                  items: items)
    }

    convenience init(from invoiceDetails: StandaloneInvoiceDetails) {
        self.init(number: invoiceDetails.number,
                  customerId: invoiceDetails.customerId,
                  customerName: invoiceDetails.customerName,
                  customerAddress: invoiceDetails.customerAddress,
                  customerDetails: invoiceDetails.customerDetails,
                  customerPhone: invoiceDetails.customerPhone,
                  customerEmail: invoiceDetails.customerEmail,
                  businessName: invoiceDetails.businessName,
                  businessPhone: invoiceDetails.businessPhone,
                  businessAddress: invoiceDetails.businessAddress,
                  businessEmail: invoiceDetails.businessEmail,
                  businessWebsite: invoiceDetails.businessWebsite,
                  date: invoiceDetails.date,
                  note: invoiceDetails.note,
                  type: invoiceDetails.type,
                  status: invoiceDetails.status)
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
        date = invoiceDetails.date
        note = invoiceDetails.note
        type = invoiceDetails.type
        status = invoiceDetails.status
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
