//
//  InvoiceOptionSelectionView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 10/08/2025.
//

import SwiftUI

struct InvoiceOptionSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptions: Set<Invoice.Options> = []

    @Binding var options: [Invoice.Options]

    var body: some View {
        NavigationStack {
            List(selection: $selectedOptions) {
                Section("انتخاب ویژگی‌ها") {
                    ForEach(Invoice.Options.allCases, id: \.self) { option in
                        Text(option.label)
                            .tag(option)
                    }
                }
            }
            .navigationTitle("تنظیمات")
            .presentationDetents([.medium, .large])
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("تا‫ئید‬") {
                        updateOptions(with: selectedOptions)

                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
        }
        .onAppear {
            selectedOptions = Set(options)
        }
    }

    func updateOptions(with selectedOptions: Set<Invoice.Options>) {
        selectedOptions.forEach { option in
            if !options.contains(option) {
                options.append(option)
            }
        }
    }
}

// #Preview {
//    InvoiceOptionSelectionView()
// }
