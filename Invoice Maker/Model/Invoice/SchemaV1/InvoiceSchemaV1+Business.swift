//
//  InvoiceSchemaV1+Business.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension InvoiceSchemaV1 {
    @Model
    class InvoiceBusiness {
        var name: String
        var phone: String
        var email: String?
        var website: String?
        var address: String?
        var invoice: VersionedInvoice?

        init(name: String, phone: String, email: String? = nil, website: String? = nil, address: String? = nil, invoice: VersionedInvoice? = nil) {
            self.name = name
            self.phone = phone
            self.email = email
            self.website = website
            self.address = address
            self.invoice = invoice
        }

        convenience init(from business: Business) {
            self.init(name: business.name,
                      phone: business.phone,
                      email: business.email,
                      website: business.website,
                      address: business.address)
        }
    }
}

extension InvoiceSchemaV1.InvoiceBusiness {
    func update(with business: Business) {
        name = business.name
        phone = business.phone
        email = business.email
        website = business.website
        address = business.address
    }
}
