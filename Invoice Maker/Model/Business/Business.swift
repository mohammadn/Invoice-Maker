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
    var address: String?
    var phone: String?
    var email: String?
    var website: String?

    init(name: String, address: String?, phone: String?, email: String?, website: String?) {
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
