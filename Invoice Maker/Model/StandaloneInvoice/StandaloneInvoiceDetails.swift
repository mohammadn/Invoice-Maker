//
//  InvoiceDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 25/02/2024.
//

import Foundation

@Observable
class StandaloneInvoiceDetails {
    var number: String
    var type: Invoice.InvoiceType
    var currency: String
    var date: Date
    var note: String
    var status: StandaloneInvoice.Status
    var items: [StandaloneItemDetails]
    var customerId: UUID?
    var customerName: String?
    var customerAddress: String?
    var customerDetails: String?
    var customerPhone: String?
    var customerEmail: String?
    var businessName: String
    var businessPhone: String
    var businessAddress: String?
    var businessEmail: String?
    var businessWebsite: String?

    var isInvalid: Bool {
        number.isEmpty || customerId == nil || items.isEmpty
    }

    init(number: String = "",
         type: Invoice.InvoiceType = .sale,
         currency: String = "IRR",
         date: Date = .now,
         note: String = "",
         status: StandaloneInvoice.Status = .pending,
         items: [StandaloneItemDetails] = [],
         customerId: UUID? = nil,
         customerName: String? = nil,
         customerAddress: String? = nil,
         customerDetails: String? = nil,
         customerPhone: String? = nil,
         customerEmail: String? = nil,
         businessName: String = "",
         businessPhone: String = "",
         businessAddress: String? = nil,
         businessEmail: String? = nil,
         businessWebsite: String? = nil) {
        self.number = number
        self.type = type
        self.currency = currency
        self.date = date
        self.note = note
        self.status = status
        self.items = items
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
    }

    convenience init(from invoice: StandaloneInvoice) {
        self.init(number: invoice.number,
                  type: invoice.type,
                  currency: invoice.currency,
                  date: invoice.date,
                  note: invoice.note,
                  status: invoice.status,
                  items: invoice.items.map { item in StandaloneItemDetails(from: item) },
                  customerId: invoice.customerId,
                  customerName: invoice.customerName,
                  customerAddress: invoice.customerAddress,
                  customerDetails: invoice.customerDetails,
                  customerPhone: invoice.customerPhone,
                  customerEmail: invoice.customerEmail,
                  businessName: invoice.businessName,
                  businessPhone: invoice.businessPhone,
                  businessAddress: invoice.businessAddress,
                  businessEmail: invoice.businessEmail,
                  businessWebsite: invoice.businessWebsite)
    }

    convenience init(with business: Business, currency: String) {
        self.init(
            currency: currency,
            businessName: business.name,
            businessPhone: business.phone,
            businessAddress: business.address,
            businessEmail: business.email,
            businessWebsite: business.website,)
    }
}

extension StandaloneInvoiceDetails: Equatable {
    static func == (lhs: StandaloneInvoiceDetails, rhs: StandaloneInvoiceDetails) -> Bool {
        let areItemsEqual: Bool = lhs.items.elementsEqual(rhs.items) { $0.productCode == $1.productCode && $0.quantity == $1.quantity }

        return lhs.number == rhs.number &&
            lhs.type == rhs.type &&
            lhs.currency == rhs.currency &&
            lhs.date == rhs.date &&
            lhs.note == rhs.note &&
            lhs.status == rhs.status &&
            areItemsEqual &&
            lhs.customerId == rhs.customerId &&
            lhs.customerName == rhs.customerName &&
            lhs.customerAddress == rhs.customerAddress &&
            lhs.customerDetails == rhs.customerDetails &&
            lhs.customerPhone == rhs.customerPhone &&
            lhs.customerEmail == rhs.customerEmail &&
            lhs.businessName == rhs.businessName &&
            lhs.businessPhone == rhs.businessPhone &&
            lhs.businessAddress == rhs.businessAddress &&
            lhs.businessEmail == rhs.businessEmail &&
            lhs.businessWebsite == rhs.businessWebsite
    }
}

extension StandaloneInvoiceDetails: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(type)
        hasher.combine(currency)
        hasher.combine(date)
        hasher.combine(note)
        hasher.combine(status)
        hasher.combine(customerId)
        hasher.combine(customerName)
        hasher.combine(customerAddress)
        hasher.combine(customerDetails)
        hasher.combine(customerPhone)
        hasher.combine(customerEmail)
        hasher.combine(businessName)
        hasher.combine(businessPhone)
        hasher.combine(businessAddress)
        hasher.combine(businessEmail)
        hasher.combine(businessWebsite)
    }
}
