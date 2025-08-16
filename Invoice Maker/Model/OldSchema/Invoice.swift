//
//  Invoice.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import Foundation
import SwiftData

@Model
class Invoice {
    init() {
    }
}

extension Invoice {
    enum InvoiceType: Codable, CaseIterable {
        case sale, proforma
    }
}
