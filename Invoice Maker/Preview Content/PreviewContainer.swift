//
//  PreviewContainer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let schema = Schema([Product.self, Business.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container = try ModelContainer(for: schema, configurations: modelConfiguration)

        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Product>()).isEmpty {
            Product.sampleData.forEach { modelContext.insert($0) }
        }

        if try modelContext.fetch(FetchDescriptor<Business>()).isEmpty {
            modelContext.insert(Business.sampleData)
        }

        return container
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}()
