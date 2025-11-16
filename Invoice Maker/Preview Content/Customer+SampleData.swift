//
//  Customer+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

#if DEBUG
    import Foundation

    extension CustomerN {
        @MainActor
        static let sampleData: [CustomerN] = [
            CustomerN(
                name: "بوتیک لباس",
                phone: "09121234567",
                email: "info@boutique.ir",
                address: "تهران، منطقه ه، محله پونك، خيابان ايران زمين، كوجه گلستان، پلاك ١۲",
                details: nil
            ),
        ]
    }
#endif
