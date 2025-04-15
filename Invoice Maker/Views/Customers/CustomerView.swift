//
//  CustomerView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/04/2025.
//

import SwiftUI

struct CustomerView: View {
    @State var isEditing: Bool = false
    
    var customer: Customer
    
    var body: some View {
        NavigationStack {
            if isEditing {
                CustomerFormView(customer: customer) {
                    isEditing.toggle()
                }
            } else {
                List {
                    Section {
                        LabeledContent("نام", value: customer.name)
                        LabeledContent("جزئیات", value: customer.details?.isEmpty == false ? customer.details! : "-")
                    }
                    
                    Section {
                        LabeledContent("تلفن", value: customer.phone?.toPersian() ?? "-")
                        LabeledContent("آدرس", value: customer.address ?? "-")
                    }
                    
                    Section {
                        LabeledContent("ایمیل", value: customer.email ?? "-")
                    }
                }
                .navigationTitle(customer.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                        Button("ویرایش") {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
        .animation(.default, value: isEditing)
    }
}

//#Preview {
//    CustomerView()
//}
