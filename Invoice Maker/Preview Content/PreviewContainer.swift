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
        let container = try ModelContainer(for: Product.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Product>()).isEmpty {
            Product.sampleData.forEach { modelContext.insert($0) }
        }

        return container
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}()
