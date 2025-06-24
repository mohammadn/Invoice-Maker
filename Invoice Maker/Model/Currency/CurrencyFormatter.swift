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
        switch currency {
        case .IRR_Toman:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.groupingSeparator = ","
            let formatted = formatter.string(from: NSDecimalNumber(decimal: value)) ?? "0"
            return "تومان \(formatted)"
        default:
            return value.formatted(.currency(code: currency.rawValue))
        }
    }
}

extension FormatStyle where Self == CurrencyFormatStyle {
    static func currencyFormatter(code currency: Currency) -> Self {
        .init(currency: currency)
    }
}
