//
//  Business+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

#if DEBUG
    import Foundation

    extension BusinessN {
        @MainActor
        static let sampleData = BusinessN(
            name: "فروشكاه اينترنتى لباس",
            phone: "تهران، منطقه ٢، خيابان آزادی، پلاک ۴۵",
            email: "09121234567",
            website: "info@cloth-shop.ir",
            address: "www.Cloth-Shop.com"
        )
    }
#endif
