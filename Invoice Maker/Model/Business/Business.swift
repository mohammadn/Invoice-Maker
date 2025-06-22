//
//  Business.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation
import SwiftData

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

    convenience init(from businessDetails: BusinessDetails) {
        self.init(name: businessDetails.name,
                  phone: businessDetails.phone,
                  email: businessDetails.email,
                  website: businessDetails.website,
                  address: businessDetails.address)
    }
}

extension Business {
    func update(with businessDetails: BusinessDetails) {
        name = businessDetails.name
        phone = businessDetails.phone
        email = businessDetails.email
        website = businessDetails.website
        address = businessDetails.address
    }
}

extension Business: Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        lhs.name == rhs.name &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email &&
            lhs.website == rhs.website &&
            lhs.address == rhs.address
    }
}

extension Business: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(phone)
        hasher.combine(email)
        hasher.combine(website)
        hasher.combine(address)
    }
}
