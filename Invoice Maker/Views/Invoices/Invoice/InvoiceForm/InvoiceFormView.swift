//
//  InvoiceFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData
import SwiftUI

struct InvoiceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [Business]
    @Query(sort: \Customer.name) private var customers: [Customer]
    @State private var showProductSelectionView: Bool = false
    @State private var showCustomerFormView: Bool = false
    @State private var showOptionSelectionView: Bool = false
    @State private var invoiceDetails: InvoiceDetails
    @State private var showDismissAlert: Bool = false

    let invoice: Invoice?
    var dismissAction: (() -> Void)?

    init(invoice: Invoice? = nil, dismissAction: (() -> Void)? = nil) {
        self.invoice = invoice
        self.dismissAction = dismissAction

        if let invoice {
            _invoiceDetails = State(initialValue: InvoiceDetails(from: invoice))
        } else {
            let defaultCurrency = UserDefaults.standard.string(forKey: "defaultCurrency") ?? "IRR"
            let currency = Currency(rawValue: defaultCurrency) ?? .IRR

            _invoiceDetails = State(initialValue: InvoiceDetails(currency: currency))
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section {
                    TextField("شماره فاکتور*", text: $invoiceDetails.number)

                    Picker("نوع فاکتور", selection: $invoiceDetails.type) {
                        ForEach(Invoice.InvoiceType.allCases, id: \.self) { type in
                            Text(type.label)
                                .tag(type)
                        }
                    }

                    Picker("نوع ارز", selection: $invoiceDetails.currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.label).tag(currency)
                        }
                    }

                    DatePicker("تاریخ صدور", selection: $invoiceDetails.date)

                    if invoiceDetails.options.contains(.dueDate) {
                        DatePicker("تاریخ سررسید", selection: $invoiceDetails.dueDate)
                    }

                    TextField("تخفیف (٪)*", value: $invoiceDetails.discount, format: .number)

                    TextField("ارزش افزوده (٪)*", value: $invoiceDetails.vat, format: .number)
                }

                Section {
                    Picker("مشتری", selection: $invoiceDetails.customerId) {
                        Text("انتخاب کنید")
                            .tag(nil as UUID?)
                        ForEach(customers) { customer in
                            Text(customer.name)
                                .tag(customer.id as UUID?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(customers.isEmpty)
                    .onChange(of: invoiceDetails.customerId) {
                        let customer = customers.first { $0.id == invoiceDetails.customerId }

                        if let customer {
                            invoiceDetails.customerName = customer.name
                            invoiceDetails.customerAddress = customer.address
                            invoiceDetails.customerDetails = customer.details
                            invoiceDetails.customerPhone = customer.phone
                            invoiceDetails.customerEmail = customer.email
                        } else {
                            invoiceDetails.customerName = nil
                            invoiceDetails.customerAddress = nil
                            invoiceDetails.customerDetails = nil
                            invoiceDetails.customerPhone = nil
                            invoiceDetails.customerEmail = nil
                        }
                    }

                    Button("افزودن مشتری", systemImage: "plus") {
                        showCustomerFormView.toggle()
                    }
                }

                Section {
                    TextField("توضیحات", text: $invoiceDetails.note, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section {
                    ForEach($invoiceDetails.items) { $item in
                        Stepper {
                            Text(item.productName)
                            Text(item.quantity.description)
                        } onIncrement: {
                            item.quantity += 1
                        } onDecrement: {
                            if item.quantity > 0 {
                                item.quantity -= 1
                            }
                        }
                    }
                    .onDelete(perform: deleteProduct)
                } header: {
                    HStack {
                        Text("محصولات")
                        Spacer()
                        Button("افزودن", systemImage: "plus") {
                            showProductSelectionView.toggle()
                        }
                    }
                }
            }
            .safeAreaPadding(.bottom, 70)

            Button {
                save()

                dismissAction?() ?? dismiss()
            } label: {
                Label("ذخیره فاکتور", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .disabled(invoiceDetails.isInvalid)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(invoice == nil ? "فاکتور جدید" : "ویرایش فاکتور")
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("انصراف") {
                    guard let invoice else {
                        showDismissAlert.toggle()
                        return
                    }

                    if InvoiceDetails(from: invoice) != invoiceDetails {
                        showDismissAlert.toggle()
                    } else {
                        dismissAction?() ?? dismiss()
                    }
                }
                .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
                    Button("انصراف", role: .cancel) {
                        showDismissAlert.toggle()
                    }
                    Button("بازگشت") {
                        dismissAction?() ?? dismiss()
                    }
                } message: {
                    Text("در صورت بازگشت به صفحه قبل اطلاعات فاکتور ذخیره نخواهد شد.")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("تنظیمات") {
                    showOptionSelectionView.toggle()
                }
            }
        }
        .sheet(isPresented: $showCustomerFormView) {
            NavigationStack {
                CustomerFormView()
            }
        }
        .sheet(isPresented: $showProductSelectionView) {
            InvoiceProductSelection(items: $invoiceDetails.items)
        }
        .sheet(isPresented: $showOptionSelectionView) {
            InvoiceOptionSelectionView(options: $invoiceDetails.options)
        }
    }

    private func save() {
        invoiceDetails.note = invoiceDetails.note.trimmingCharacters(in: .whitespacesAndNewlines)

        if let invoice {
            invoice.update(with: invoiceDetails)

            invoiceDetails.items.forEach { item in
                if let existingItem = invoice.items.first(where: { $0.productCode == item.productCode }) {
                    existingItem.update(with: item)
                } else {
                    let item = InvoiceItem(from: item)
                    invoice.items.append(item)
                }
            }

            invoice.items.forEach { item in
                if (!invoiceDetails.items.contains { $0.productCode == item.productCode }) {
                    modelContext.delete(item)
                }
            }
        } else {
            guard let business = business.first else { return }
            let invoiceCustomer = InvoiceCustomer(from: invoiceDetails)
            let invoiceBusiness = InvoiceBusiness(from: business)

            let invoice = Invoice(from: invoiceDetails, customer: invoiceCustomer, business: invoiceBusiness)

            invoiceDetails.items.forEach {
                let item = InvoiceItem(from: $0)
                invoice.items.append(item)
            }

            modelContext.insert(invoice)
        }

        try? modelContext.save()
    }

    private func deleteProduct(at indexSet: IndexSet) {
        indexSet.forEach { index in
            invoiceDetails.items.remove(at: index)
        }
    }
}

// #Preview {
//    InvoiceFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
