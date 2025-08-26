//
//  VATDiscountConverter.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 26/08/2025.
//

import SwiftData
import Foundation

@MainActor
final class VATDiscountConverter {
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    func convertVATDiscountToDecimal() async throws {
        // Check if VAT/Discount conversion has already been performed
        let conversionKey = "VATDiscountDecimalConversionCompleted"
        guard !UserDefaults.standard.bool(forKey: conversionKey) else {
            print("VAT/Discount decimal conversion already completed, skipping...")
            return
        }

        print("Starting VAT/Discount decimal conversion...")
        
        let context = ModelContext(container)
        
        // Fetch all invoices from current schema
        let descriptor = FetchDescriptor<SchemaV1.Invoice>()
        let invoices = try context.fetch(descriptor)
        
        var convertedCount = 0
        
        for invoice in invoices {
            var needsUpdate = false
            let originalVAT = invoice.vat
            let originalDiscount = invoice.discount
            
            // Convert VAT if it's a whole number percentage (> 1.0)
            // This assumes values like 5, 10, 15 should become 0.05, 0.10, 0.15
            if invoice.vat > 1.0 {
                invoice.vat = invoice.vat / 100.0
                needsUpdate = true
                print("Converted VAT from \(originalVAT) to \(invoice.vat) for invoice \(invoice.number)")
            }
            
            // Convert Discount if it's a whole number percentage (> 1.0)
            // This assumes values like 5, 10, 15 should become 0.05, 0.10, 0.15
            if invoice.discount > 1.0 {
                invoice.discount = invoice.discount / 100.0
                needsUpdate = true
                print("Converted Discount from \(originalDiscount) to \(invoice.discount) for invoice \(invoice.number)")
            }
            
            if needsUpdate {
                convertedCount += 1
            }
        }
        
        // Save changes if any conversions were made
        if convertedCount > 0 {
            try context.save()
            print("Converted VAT/Discount values for \(convertedCount) invoices")
        } else {
            print("No VAT/Discount conversions needed")
        }
        
        // Mark conversion as complete
        UserDefaults.standard.set(true, forKey: conversionKey)
        print("VAT/Discount decimal conversion completed successfully")
    }
}