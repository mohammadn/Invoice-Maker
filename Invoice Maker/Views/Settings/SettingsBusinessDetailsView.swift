//
//  SettingsBusinessDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct SettingsBusinessDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var businessDetails: BusinessDetails
//    @State private var logo: String = ""

    var business: Business?

    init(business: Business? = nil) {
        self.business = business

        if let business {
            _businessDetails = State(initialValue: BusinessDetails(from: business))
        } else {
            _businessDetails = State(initialValue: BusinessDetails())
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("نام کسب و کار*", text: $businessDetails.name)
                TextField("شماره تماس*", text: $businessDetails.phone)
            }

            Section {
                TextField("آدرس", text: $businessDetails.address ?? "", axis: .vertical)
                    .lineLimit(3 ... 5)
            }

            Section {
                TextField("ایمیل", text: $businessDetails.email ?? "")
                TextField("وبسایت", text: $businessDetails.website ?? "")
            }

//            Section {
//                TextField("لوگو", text: $logo)
//            }
        }
        .navigationTitle("اطلاعات کسب و کار")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("ذخیره") {
                    if let business {
                        business.update(with: businessDetails)
                    } else {
                        let business = Business(from: businessDetails)

                        modelContext.insert(business)
                    }

                    dismiss()
                }
                .disabled(businessDetails.isInvalid)
            }
        }
    }
}

// #Preview {
//    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//
//    let container = try! ModelContainer(for: Business.self,
//                                        configurations: configuration)
//    NavigationStack {
//        SettingsBusinessDetailsView(business: Business.sampleData)
//    }
//    .modelContainer(container)
//    .environment(\.layoutDirection, .rightToLeft)
// }
