//
//  Decimal+Rounded.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 24/06/2025.
//

import Foundation

extension Decimal {
    func rounded(scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var result = Decimal()
        var original = self
        NSDecimalRound(&result, &original, scale, mode)
        return result
    }
}
