//
//  InvoiceDetailView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/05/2025.
//

import SwiftData
import SwiftUI

struct InvoiceDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showCustomerSection: Bool = false
    @State private var showBusinessSection: Bool = false
    @State private var showProductsSection: Bool = false
    @State private var generatedPDF: URL?
    @State private var customer: Customer?
    @State private var business: Business?
    @State private var products: [VersionedProduct] = []

    let invoice: VersionedInvoice
    @Binding var isEditing: Bool

    var body: some View {
        List {
            Section {
                LabeledContent("شماره فاکتور", value: invoice.number)
                LabeledContent("نوع فاکتور", value: invoice.type.label)
                LabeledContent("نوع ارز", value: Locale.current.localizedString(forCurrencyCode: invoice.currency) ?? "-")
                LabeledContent("تاریخ", value: invoice.date, format: .dateTime)
                LabeledContent("توضیحات", value: invoice.note.isEmpty ? "-" : invoice.note)
            }

            Section(isExpanded: $showCustomerSection) {
                LabeledContent("نام", value: invoice.customerName ?? "-")
                LabeledContent("شماره تماس", value: invoice.customerPhone ?? "-")
                LabeledContent("ایمیل", value: invoice.customerEmail ?? "-")
                LabeledContent("آدرس", value: invoice.customerAddress ?? "-")
                LabeledContent("توضیحات", value: invoice.customerDetails ?? "-")
            } header: {
                HStack {
                    Text("مشتری")

                    if let customer, customer != invoice.customer {
                        ButtonWithPopover(text: "اطلاعات مشتری تغییر کرده است. در صورت نیاز می توانید اطلاعات را بروزرسانی کنید.") {
                            invoice.updateCustomer(with: customer)

                            generatePDF()
                        }
                    }

                    Spacer()

                    Button {
                        showCustomerSection.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .rotationEffect(.degrees(showCustomerSection ? 90 : 0))
                    }
                }
            }

            Section(isExpanded: $showBusinessSection) {
                LabeledContent("نام", value: invoice.businessName)
                LabeledContent("شماره تماس", value: invoice.businessPhone)
                LabeledContent("ایمیل", value: invoice.businessEmail ?? "-")
                LabeledContent("وب سایت", value: invoice.businessWebsite ?? "-")
                LabeledContent("آدرس", value: invoice.businessAddress ?? "-")
            } header: {
                HStack {
                    Text("کسب و کار")

                    if let business, business != invoice.business {
                        ButtonWithPopover(text: "اطلاعات کسب و کار تغییر کرده است. در صورت نیاز می توانید اطلاعات را بروزرسانی کنید.") {
                            invoice.updateBusiness(with: business)

                            generatePDF()
                        }
                    }

                    Spacer()

                    Button {
                        showBusinessSection.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .rotationEffect(.degrees(showBusinessSection ? 90 : 0))
                    }
                }
            }

            Section(isExpanded: $showProductsSection) {
                ForEach(invoice.items) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.productName)
                                .lineLimit(1)

                            Spacer()

                            Text(item.quantity, format: .number)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Text(item.productPrice, format: .currency(code: item.productCurrency))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
            } header: {
                HStack {
                    Text("محصولات")

                    if Set(invoice.items.compactMap(\.product)) != Set(products) {
                        ButtonWithPopover(text: "اطلاعات یک یا چند محصول تغییر کرده است. در صورت نیاز می‌توانید اطلاعات را بروزرسانی کنید.") {
                            for item in invoice.items {
                                if let product = products.first(where: { $0.code == item.productCode }) {
                                    item.update(with: product)
                                }
                            }

                            generatePDF()
                        }
                    }

                    Spacer()

                    Button {
                        showProductsSection.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                            .rotationEffect(.degrees(showProductsSection ? 90 : 0))
                    }
                }
            }
        }
        .navigationTitle(invoice.number)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                Menu {
                    Button("ویرایش", systemImage: "pencil") {
                        isEditing.toggle()
                    }

                    if let generatedPDF {
                        ShareLink("پرینت", item: generatedPDF)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            if let customerId = invoice.customerId {
                let customerDescriptor = FetchDescriptor<Customer>(
                    predicate: #Predicate<Customer> { $0.id == customerId },
                    sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
                )
                customer = (try? modelContext.fetch(customerDescriptor))?.first
            }

            let businessDescriptor = FetchDescriptor<Business>()
            business = (try? modelContext.fetch(businessDescriptor))?.first

            let productCodes = invoice.items.map { $0.productCode }
            let productDescriptor = FetchDescriptor<VersionedProduct>(
                predicate: #Predicate<VersionedProduct> { productCodes.contains($0.code) },
                sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
            )
            products = (try? modelContext.fetch(productDescriptor)) ?? []

            generatePDF()
        }
        .animation(.easeInOut, value: showBusinessSection)
        .animation(.easeInOut, value: showCustomerSection)
        .animation(.easeInOut, value: showProductsSection)
    }

    private func generatePDF() {
        guard !invoice.isInvalid else { return }

        let pdf = PDF(invoice: invoice)
        generatedPDF = pdf.generatePDF()
    }
}

// #Preview {
//    InvoiceDetailView()
// }
