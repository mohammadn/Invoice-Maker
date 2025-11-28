//
//  InvoiceOptionSelectionView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 10/08/2025.
//

import SwiftUI

struct InvoiceOptionSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptions: Set<InvoiceN.Option> = []

    @Binding var options: [InvoiceN.Option]

    var body: some View {
        NavigationStack {
            List(selection: $selectedOptions) {
                Section("انتخاب ویژگی‌ها") {
                    ForEach(InvoiceN.Option.allCases, id: \.self) { option in
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
                    Button(role: .close) {
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

    func updateOptions(with selectedOptions: Set<InvoiceN.Option>) {
        options = Array(selectedOptions)
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var options: [InvoiceN.Option] = []

        InvoiceOptionSelectionView(options: $options)
    }
#endif
