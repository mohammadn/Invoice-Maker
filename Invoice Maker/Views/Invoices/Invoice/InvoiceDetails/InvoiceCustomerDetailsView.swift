//
//  InvoiceCustomerDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 29/06/2025.
//

import SwiftUI

struct InvoiceCustomerDetailsView: View {
    let invoice: InvoiceN

    var body: some View {
        LabeledContent("نام", value: invoice.customer?.name?.isEmpty == false ? invoice.customer!.name! : "-")
        LabeledContent("شماره تماس", value: invoice.customer?.phone?.isEmpty == false ? invoice.customer!.phone! : "-")
        LabeledContent("ایمیل", value: invoice.customer?.email?.isEmpty == false ? invoice.customer!.email! : "-")
        LabeledContent("آدرس", value: invoice.customer?.address?.isEmpty == false ? invoice.customer!.address! : "-")
        LabeledContent("توضیحات", value: invoice.customer?.details?.isEmpty == false ? invoice.customer!.details! : "-")
    }
}

#if DEBUG
    #Preview {
        List {
            InvoiceCustomerDetailsView(invoice: InvoiceN.sampleData[0])
        }
        .modelContainer(previewContainer)
    }
#endif
