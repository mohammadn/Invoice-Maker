//
//  PreviewContainer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation
import SwiftData

@MainActor
public let previewContainer: ModelContainer = {
    do {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        let container = try ModelContainer(for: schema, configurations: modelConfiguration)

        let modelContext = container.mainContext

        if try modelContext.fetch(FetchDescriptor<Business>()).isEmpty {
            modelContext.insert(Business.sampleData)
        }

//        if try modelContext.fetch(FetchDescriptor<Product>()).isEmpty {
//            Product.sampleData.forEach { modelContext.insert($0) }
//        }

        if try modelContext.fetch(FetchDescriptor<Customer>()).isEmpty {
            Customer.sampleData.forEach { modelContext.insert($0) }
        }

        return container
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}()
