//
//  PDF.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 25/02/2024.
//

import Foundation
import TPPDF
import UIKit

struct PDF {
    let invoice: Invoice
    let business: Business

    func generatePDF() -> URL? {
        let document = PDFDocument(format: .a4)
        document.layout.margin = EdgeInsets(top: 72, left: 36, bottom: 72, right: 36)

        // **Document Info**
        document.info.title = "Invoice \(invoice.number)"
        document.info.author = business.name

        // **Title Section**
        let attributedTitle = NSMutableAttributedString(string: invoice.type.label, attributes: [.font: UIFont.systemFont(ofSize: .init(30), weight: .bold)])
        let attributedNumber = NSMutableAttributedString(string: "شماره فاکتور:  " + invoice.number.toPersian(),
                                                         attributes: [
                                                             .font: UIFont.systemFont(ofSize: .init(14)),
                                                         ])
        let attributedDate = NSMutableAttributedString(string: "تاریخ:  " + formattedDate(invoice.date),
                                                       attributes: [
                                                           .font: UIFont.systemFont(ofSize: .init(14)),
                                                       ])

        document.add(.headerRight, attributedText: attributedTitle)

        document.add(.headerLeft, attributedText: attributedNumber)
        document.add(.headerLeft, attributedText: attributedDate)

        document.add(space: 20)

        let comma = NSMutableAttributedString(string: "  ,  ", attributes: [:])

        // Customer Information
        let customerDetailsTable = PDFTable(rows: 2, columns: 1)
        customerDetailsTable.padding = 5

        let customerDetails = NSMutableAttributedString()
        customerDetails.append(createAttributedString(label: "نام", value: invoice.customer.name))

        if let phone = invoice.customer.phone, !phone.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "تلفن", value: phone))
        }

        if let email = invoice.customer.email, !email.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "ایمیل", value: email))
        }

        if let address = invoice.customer.address, !address.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "آدرس", value: address))
        }

        customerDetailsTable[0, 0].content = try? PDFTableContent(content: "خریدار:")
        customerDetailsTable[1, 0].content = try? PDFTableContent(content: customerDetails)

        customerDetailsTable[row: 0].allCellsStyle = PDFTableCellStyle(colors: (fill: UIColor.lightGray, text: UIColor.white), font: Font.systemFont(ofSize: 14))
        customerDetailsTable[rows: 0 ... 1].allCellsAlignment = .right

        document.add(table: customerDetailsTable)
        document.add(space: 10)

        // Items Table
        let table = createItemsTable()
        document.add(table: table)
        document.add(space: 20)

        // Summary Section
        let lastRow = table.size.rows - 1
        table[lastRow, 1].content = try? PDFTableContent(content: "جمع کل (ریال)")
        table[lastRow, 0].content = try? PDFTableContent(content: "\(formattedNumber(invoice.total))")
        table[rows: lastRow, columns: 1 ... 3].merge()
        document.add(space: 20)

        // Notes and Terms
        document.add(.contentRight, text: "توضیحات:")
        document.add(.contentRight, text: invoice.note)

        // Business Details
        let businessDetails = NSMutableAttributedString()
        businessDetails.append(createAttributedString(label: "نام", value: business.name))

        if let phone = business.phone, !phone.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "تلفن", value: phone))
        }

        if let website = business.website, !website.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "وبسایت", value: website))
        }

        if let email = business.email, !email.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "ایمیل", value: email))
        }

        if let address = business.address, !address.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "آدرس", value: address))
        }

        document.add(.footerCenter, attributedText: businessDetails)

        // Generate PDF
        let generator = TPPDF.PDFGenerator(document: document)
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(invoice.number).pdf")
        do {
            try generator.generate(to: tempURL)
            return tempURL
        } catch {
            print("Error generating PDF: \(error)")
            return nil
        }
    }

    // Helper Functions
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "fa_IR")
        return formatter.string(from: date)
    }

    private func formattedNumber(_ inputStr: Int) -> String {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "fa_IR")
        let number = format.number(from: String(inputStr))
        let faNumber = format.string(from: number!)
        return faNumber!
    }

    private func createItemsTable() -> PDFTable {
        let table = PDFTable(rows: invoice.items.count + 2, columns: 5)
        table.widths = [0.2, 0.3, 0.1, 0.3, 0.1]
        table.padding = 5

        // **Table Headers**
        table[0, 0].content = try? PDFTableContent(content: "قیمت کل (ریال)")
        table[0, 1].content = try? PDFTableContent(content: "قیمت واحد (ریال)")
        table[0, 2].content = try? PDFTableContent(content: "تعداد")
        table[0, 3].content = try? PDFTableContent(content: "نام محصول")
        table[0, 4].content = try? PDFTableContent(content: "ردیف")
        table[row: 0].allCellsStyle = PDFTableCellStyle(colors: (fill: UIColor.lightGray, text: UIColor.white), font: Font.systemFont(ofSize: 14))

        // **Table Content**
        for (index, item) in invoice.items.enumerated() {
            let row = index + 1
            table[row, 0].content = try? PDFTableContent(content: String(item.product.price * item.quantity).toPersian())
            table[row, 1].content = try? PDFTableContent(content: item.product.price.description.toPersian())
            table[row, 2].content = try? PDFTableContent(content: item.quantity.description)
            table[row, 3].content = try? PDFTableContent(content: item.product.name)
            table[row, 4].content = try? PDFTableContent(content: row)
        }

        return table
    }

    private func createAttributedString(label: String, value: String) -> NSMutableAttributedString {
        let bold: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold)]

        let label = NSMutableAttributedString(string: "\(label): ", attributes: bold)
        let value = NSMutableAttributedString(string: value, attributes: [:])
        label.append(value)
        return label
    }
}
