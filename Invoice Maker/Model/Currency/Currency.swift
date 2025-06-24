//
//  Currency.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 22/06/2025.
//

enum Currency: String, Codable, CaseIterable {
    case IRR
    case IRR_Toman

    var label: String {
        switch self {
        case .IRR: "ریال"
        case .IRR_Toman: "تومان"
        }
    }
}
