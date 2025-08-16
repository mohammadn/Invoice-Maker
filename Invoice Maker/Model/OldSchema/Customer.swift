//
//  Customer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Contacts
import Foundation
import SwiftData

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
}

extension Customer: Equatable {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.address == rhs.address &&
            lhs.details == rhs.details &&
            lhs.phone == rhs.phone &&
            lhs.email == rhs.email
    }
}

extension Customer: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(details)
        hasher.combine(phone)
        hasher.combine(email)
    }
}
