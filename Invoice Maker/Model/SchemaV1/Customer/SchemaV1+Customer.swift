//
//  SchemaV1+Customer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 02/08/2025.
//

import Contacts
import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class Customer: Identifiable {
        var id: UUID = UUID()
        var name: String
        var phone: String?
        var email: String?
        var address: String?
        var details: String?
        var createdDate: Date = Date.now

        init(id: UUID = UUID(), name: String, address: String?, details: String?, phone: String?, email: String?) {
            self.id = id
            self.name = name
            self.address = address
            self.details = details
            self.phone = phone
            self.email = email
        }

        convenience init(from customerDetails: CustomerDetailsV1) {
            self.init(id: customerDetails.id,
                      name: customerDetails.name,
                      address: customerDetails.address,
                      details: customerDetails.details,
                      phone: customerDetails.phone,
                      email: customerDetails.email)
        }

        convenience init(from contact: CNContact) {
            self.init(name: contact.formattedName,
                      address: contact.address,
                      details: nil,
                      phone: contact.phone,
                      email: contact.email)
        }
    }
}

extension SchemaV1.Customer {
    func update(with customerDetails: CustomerDetailsV1) {
        name = customerDetails.name
        address = customerDetails.address
        details = customerDetails.details
        phone = customerDetails.phone
        email = customerDetails.email
    }
}

extension SchemaV1.Customer: Equatable {
    static func == (lhs: SchemaV1.Customer, rhs: SchemaV1.Customer) -> Bool {
        lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.address == rhs.address &&
            lhs.details == rhs.details &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email
    }
}

extension SchemaV1.Customer: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(details)
        hasher.combine(phone)
        hasher.combine(email)
    }
}
