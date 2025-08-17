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
    @State private var generatedPDF: URL?
    @State private var customer: CustomerN?
    @State private var business: BusinessN?
    @State private var products: [Product] = []

    let invoice: InvoiceN
    @Binding var isEditing: Bool

    var body: some View {
        List {
            InvoiceMainDetailsView(invoice: invoice)

            ExpandableSectionView {
                InvoiceCustomerDetailsView(invoice: invoice)
            } header: {
                Text("مشتری")

                if let customer, customer != invoice.getCustomer {
                    ButtonWithPopover(text: "اطلاعات مشتری تغییر کرده است. در صورت نیاز می توانید اطلاعات را بروزرسانی کنید.") {
                        invoice.customer?.update(with: customer)

                        generatePDF()
                    }
                }
            }

            ExpandableSectionView {
                LabeledContent("نام", value: invoice.business?.name ?? "-")
                LabeledContent("شماره تماس", value: invoice.business?.phone ?? "-")
                LabeledContent("ایمیل", value: invoice.business?.email ?? "-")
                LabeledContent("وب سایت", value: invoice.business?.website ?? "-")
                LabeledContent("آدرس", value: invoice.business?.address ?? "-")
            } header: {
                Text("کسب و کار")

                if let business, business != invoice.getBusiness {
                    ButtonWithPopover(text: "اطلاعات کسب و کار تغییر کرده است. در صورت نیاز می توانید اطلاعات را بروزرسانی کنید.") {
                        invoice.business?.update(with: business)

                        generatePDF()
                    }
                }
            }

            ExpandableSectionView {
                InvoiceProductDetailsView(invoice: invoice)
            } header: {
                Text("محصولات")

                if hasProductChanges() {
                    ButtonWithPopover(text: "اطلاعات یک یا چند محصول تغییر کرده است. در صورت نیاز می‌توانید اطلاعات را بروزرسانی کنید.") {
                        for item in invoice.items {
                            if let product = products.first(where: { $0.id == item.productId }) {
                                item.update(with: product)
                            }
                        }

                        generatePDF()
                    }
                }
            }
        }
        .navigationTitle(invoice.number)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("ویرایش", systemImage: "pencil") {
                        isEditing.toggle()
                    }

                    if let generatedPDF {
                        ShareLink("اشتراک گذاری", item: generatedPDF)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            if let customerId = invoice.customer?.id {
                let customerDescriptor = FetchDescriptor<CustomerN>(
                    predicate: #Predicate<CustomerN> { $0.id == customerId },
                    sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
                )
                customer = (try? modelContext.fetch(customerDescriptor))?.first
            }

            let businessDescriptor = FetchDescriptor<BusinessN>()
            business = (try? modelContext.fetch(businessDescriptor))?.first

            let productIds = invoice.items.map { $0.productId }
            let productDescriptor = FetchDescriptor<Product>(
                predicate: #Predicate<Product> { productIds.contains($0.id) },
                sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
            )
            products = (try? modelContext.fetch(productDescriptor)) ?? []

            generatePDF()
        }
    }

    private func hasProductChanges() -> Bool {
        invoice.items.contains { item in
            guard let currentProduct = products.first(where: { $0.id == item.productId }) else {
                return false
            }
            return item.product != currentProduct
        }
    }

    private func generatePDF() {
        guard !invoice.isInvalid else { return }

        let pdf = PDF(invoice: invoice)
        generatedPDF = pdf.generatePDF()
    }
}

#Preview {
    @Previewable @State var isEditing: Bool = false

    NavigationStack {
        InvoiceDetailView(invoice: InvoiceN.sampleData[0], isEditing: $isEditing)
    }
    .modelContainer(previewContainer)
}
