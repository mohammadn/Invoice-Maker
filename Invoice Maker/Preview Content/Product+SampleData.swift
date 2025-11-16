//
//  Product+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

#if DEBUG
    import Foundation

    extension Product {
        @MainActor
        static let sampleData: [Product] = [
            Product(
                code: 1,
                name: "شلوار جین زارا",
                price: 600000,
                currency: .IRR_Toman,
                details: "ابی روشن",
            ),
            Product(
                code: 2,
                name: "شومیز زارا",
                price: 1200000,
                currency: .IRR,
                details: "سفید",
            ),
        ]
    }
#endif
