//
//  NullishCoalescingBinding.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 09/01/2025.
//

import SwiftUI

func ?? <T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
