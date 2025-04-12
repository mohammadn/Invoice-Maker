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
    var date: Date
    var note: String
    var type: Invoice.InvoiceType
    var items: [StandaloneItemDetails]
    var status: StandaloneInvoice.Status

    var isInvalid: Bool {
        number.isEmpty || customerId == nil || items.isEmpty
    }

    init(number: String = "",
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
         businessWebsite: String? = nil,
         date: Date = .now,
         note: String = "",
         type: Invoice.InvoiceType = .sale,
         items: [StandaloneItemDetails] = [],
         status: StandaloneInvoice.Status = .pending) {
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

    convenience init(from invoice: StandaloneInvoice) {
        self.init(number: invoice.number,
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
                  businessWebsite: invoice.businessWebsite,
                  date: invoice.date,
                  note: invoice.note,
                  type: invoice.type,
                  items: invoice.items.map { item in StandaloneItemDetails(from: item) },
                  status: invoice.status)
    }
}

extension StandaloneInvoiceDetails: Equatable {
    static func == (lhs: StandaloneInvoiceDetails, rhs: StandaloneInvoiceDetails) -> Bool {
        let areItemsEqual: Bool = lhs.items.elementsEqual(rhs.items) { $0.productCode == $1.productCode && $0.quantity == $1.quantity }

        return lhs.number == rhs.number &&
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
            lhs.businessWebsite == rhs.businessWebsite &&
            lhs.date == rhs.date &&
            lhs.note == rhs.note &&
            lhs.type == rhs.type &&
            lhs.status == rhs.status &&
            areItemsEqual
    }
}
