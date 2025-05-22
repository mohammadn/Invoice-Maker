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

    init(name: String, address: String?, phone: String, email: String?, website: String?) {
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
        self.website = website
    }

    convenience init(from businessDetails: BusinessDetails) {
        self.init(name: businessDetails.name,
                  address: businessDetails.address,
                  phone: businessDetails.phone,
                  email: businessDetails.email,
                  website: businessDetails.website)
    }
}

extension Business {
    func update(with businessDetails: BusinessDetails) {
        name = businessDetails.name
        address = businessDetails.address
        phone = businessDetails.phone
        email = businessDetails.email
        website = businessDetails.website
    }
}

extension Business: Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        lhs.name == rhs.name &&
            lhs.address == rhs.address &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email &&
            lhs.website == rhs.website
    }
}

extension Business: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(phone)
        hasher.combine(email)
        hasher.combine(website)
    }
}
