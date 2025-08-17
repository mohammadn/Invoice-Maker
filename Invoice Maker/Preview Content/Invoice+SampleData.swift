//
//  Invoice+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

extension InvoiceN {
    @MainActor
    static let sampleData: [InvoiceN] = [
        InvoiceN(
            number: "1",
            type: .sale,
            currency: .IRR,
            date: Date(),
            dueDate: Date(),
            vat: 10,
            discount: 5,
            note: "",
            status: .pending,
            options: [],
            items: [],
            customer: nil,
            business: nil
        ),
    ]

    @MainActor
    static let bustinessesSampleData: [InvoiceBusiness] = [
        InvoiceBusiness(
            name: "فروشكاه اينترنتى لباس",
            phone: "تهران، منطقه ٢، خيابان آزادی، پلاک ۴۵",
            email: "09121234567",
            website: "info@cloth-shop.ir",
            address: "www.Cloth-Shop.com"
        ),
    ]

    @MainActor
    static let customersSampleData: [InvoiceCustomer] = [
        InvoiceCustomer(
            id: UUID(),
            name: "بوتیک لباس",
            phone: "09121234567",
            email: "info@boutique.ir",
            address: "تهران، منطقه ه، محله پونك، خيابان ايران زمين، كوجه گلستان، پلاك ١۲",
            details: ""
        ),
    ]

    @MainActor
    static let itemsSampleData: [InvoiceItem] = [
        InvoiceItem(
            productId: UUID(),
            productCode: 1,
            productName: "شلوار جین زارا",
            productPrice: 600000,
            productCurrency: .IRR_Toman,
            productDetails: "ابی روشن",
            quantity: 1
        ),
        InvoiceItem(
            productId: UUID(),
            productCode: 2,
            productName: "شومیز زارا",
            productPrice: 1200000,
            productCurrency: .IRR,
            productDetails: "سفید",
            quantity: 1
        ),
    ]
}
