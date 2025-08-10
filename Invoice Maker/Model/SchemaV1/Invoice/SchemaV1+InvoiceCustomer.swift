//
//  SchemaV1+InvoiceCustomer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class InvoiceCustomer {
        var id: UUID
        var name: String
        var phone: String?
        var email: String?
        var address: String?
        var details: String?
        var invoice: SchemaV1.Invoice?

        init(id: UUID, name: String, phone: String? = nil, email: String? = nil, address: String? = nil, details: String? = nil) {
            self.id = id
            self.name = name
            self.phone = phone
            self.email = email
            self.address = address
            self.details = details
        }

        convenience init(from customer: SchemaV1.Customer) {
            self.init(id: customer.id,
                      name: customer.name,
                      phone: customer.phone,
                      email: customer.email,
                      address: customer.address,
                      details: customer.details)
        }

        convenience init?(from invoiceDetails: InvoiceDetailsV1) {
            guard let customerId = invoiceDetails.customerId,
                  let customerName = invoiceDetails.customerName else {
                return nil
            }

            self.init(id: customerId,
                      name: customerName,
                      phone: invoiceDetails.customerPhone,
                      email: invoiceDetails.customerEmail,
                      address: invoiceDetails.customerAddress,
                      details: invoiceDetails.customerDetails)
        }
    }
}

extension SchemaV1.InvoiceCustomer {
    func update(with customer: SchemaV1.Customer) {
        id = customer.id
        name = customer.name
        phone = customer.phone
        email = customer.email
        address = customer.address
        details = customer.details
    }
}
