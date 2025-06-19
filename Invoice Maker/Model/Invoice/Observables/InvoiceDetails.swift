//
//  InvoiceDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 25/02/2024.
//

import Foundation

@Observable
class InvoiceDetails {
    var number: String
    var type: Invoice.InvoiceType
    var currency: String
    var date: Date
    var note: String
    var status: VersionedInvoice.Status
    var items: [ItemDetails]
    var customerId: UUID?
    var customerName: String?
    var customerAddress: String?
    var customerDetails: String?
    var customerPhone: String?
    var customerEmail: String?

    var customer: InvoiceCustomer? {
        guard let customerId, let customerName else { return nil }

        return InvoiceCustomer(id: customerId, name: customerName, phone: customerPhone, email: customerEmail, address: customerAddress, details: customerDetails)
    }

    var isInvalid: Bool {
        number.isEmpty || customerId == nil || items.isEmpty
    }

    init(number: String = "",
         type: Invoice.InvoiceType = .sale,
         currency: String = "IRR",
         date: Date = .now,
         note: String = "",
         status: VersionedInvoice.Status = .pending,
         items: [ItemDetails] = [],
         customerId: UUID? = nil,
         customerName: String? = nil,
         customerAddress: String? = nil,
         customerDetails: String? = nil,
         customerPhone: String? = nil,
         customerEmail: String? = nil,) {
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
    }

    convenience init(from invoice: VersionedInvoice) {
        self.init(number: invoice.number,
                  type: invoice.type,
                  currency: invoice.currency,
                  date: invoice.date,
                  note: invoice.note,
                  status: invoice.status,
                  items: invoice.items.map { item in ItemDetails(from: item) },
                  customerId: invoice.customer?.id,
                  customerName: invoice.customer?.name,
                  customerAddress: invoice.customer?.address,
                  customerDetails: invoice.customer?.details,
                  customerPhone: invoice.customer?.phone,
                  customerEmail: invoice.customer?.email,)
    }
}

extension InvoiceDetails: Equatable {
    static func == (lhs: InvoiceDetails, rhs: InvoiceDetails) -> Bool {
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
            lhs.customerEmail == rhs.customerEmail
    }
}

extension InvoiceDetails: Hashable {
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
    }
}
