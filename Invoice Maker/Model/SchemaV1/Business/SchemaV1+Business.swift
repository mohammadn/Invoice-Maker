//
//  SchemaV1+Business.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 02/08/2025.
//

import Foundation
@preconcurrency import SwiftData

extension SchemaV1 {
    @Model
    class Business {
        var name: String
        var phone: String
        var email: String?
        var website: String?
        var address: String?

        init(name: String, phone: String, email: String?, website: String?, address: String?) {
            self.name = name
            self.phone = phone
            self.email = email
            self.website = website
            self.address = address
        }

        convenience init(from businessDetails: BusinessDetailsV1) {
            self.init(name: businessDetails.name,
                      phone: businessDetails.phone,
                      email: businessDetails.email,
                      website: businessDetails.website,
                      address: businessDetails.address)
        }
    }
}

extension SchemaV1.Business {
    func update(with businessDetails: BusinessDetailsV1) {
        name = businessDetails.name
        phone = businessDetails.phone
        email = businessDetails.email
        website = businessDetails.website
        address = businessDetails.address
    }
}

extension SchemaV1.Business: Equatable {
    static func == (lhs: SchemaV1.Business, rhs: SchemaV1.Business) -> Bool {
        lhs.name == rhs.name &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email &&
            lhs.website == rhs.website &&
            lhs.address == rhs.address
    }
}

extension SchemaV1.Business: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(phone)
        hasher.combine(email)
        hasher.combine(website)
        hasher.combine(address)
    }
}
