//
//  MigrationPlan.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 31/05/2025.
//

import Foundation
@preconcurrency import SwiftData

class MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
