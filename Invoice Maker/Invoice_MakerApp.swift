//
//  Invoice_MakerApp.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

@main
struct Invoice_MakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Product.self)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
