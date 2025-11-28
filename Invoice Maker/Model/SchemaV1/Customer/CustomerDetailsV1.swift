//
//  CustomerDetailsV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation

@Observable
class CustomerDetailsV1 {
    var name: String
    var phone: String
    var email: String
    var address: String
    var details: String

    var isInvalid: Bool {
        name.isEmpty
    }

    var isDirty: Bool {
        !name.isEmpty ||
            !phone.isEmpty ||
            !email.isEmpty ||
            !address.isEmpty ||
            !details.isEmpty
    }

    init(name: String = "", phone: String = "", email: String = "", address: String = "", details: String = "") {
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
        self.details = details
    }

    convenience init(from customer: SchemaV1.Customer) {
        self.init(name: customer.name ?? "",
                  phone: customer.phone ?? "",
                  email: customer.email ?? "",
                  address: customer.address ?? "",
                  details: customer.details ?? ""
        )
    }
}

extension CustomerDetailsV1: Equatable {
    static func == (lhs: CustomerDetailsV1, rhs: CustomerDetailsV1) -> Bool {
        lhs.name == rhs.name &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email &&
            lhs.address == rhs.address &&
            lhs.details == rhs.details
    }
}
