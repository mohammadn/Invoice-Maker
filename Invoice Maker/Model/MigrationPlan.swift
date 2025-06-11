//
//  MigrationPlan.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 31/05/2025.
//

@preconcurrency import SwiftData

class MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [ProductSchemaV1.self, InvoiceSchemaV1.self]
    }

    static var stages: [MigrationStage] { [] }
}
