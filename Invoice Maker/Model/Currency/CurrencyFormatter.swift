//
//  CurrencyFormatter.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 24/06/2025.
//

import Foundation

struct CurrencyFormatStyle: FormatStyle {
    var currency: Currency

    func format(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "fa")

        switch currency {
        case .IRR_Toman:
            formatter.numberStyle = .decimal
            let formatted = formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0"
            return "تومان \(formatted)"
        case .IRR:
            formatter.numberStyle = .decimal
            let formatted = formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0"
            return "ریال \(formatted)"
//        default:
//            formatter.numberStyle = .currency
//            formatter.currencyCode = currency.rawValue
//            let formatted = formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0"
//            return formatted
        }
    }
}

extension FormatStyle where Self == CurrencyFormatStyle {
    static func currencyFormatter(code currency: Currency) -> Self {
        .init(currency: currency)
    }
}
