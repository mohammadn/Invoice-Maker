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
    let invoice: InvoiceN
    let systemGray5 = UIColor(red: 216 / 255, green: 216 / 255, blue: 220 / 255, alpha: 1)
    let systemGray6 = UIColor(red: 235 / 255, green: 235 / 255, blue: 240 / 255, alpha: 1)

    func generatePDF() -> URL? {
        let document = PDFDocument(format: .a4)
        document.layout.margin = EdgeInsets(top: 72, left: 36, bottom: 72, right: 36)

        // Document Info
        document.info.title = "Invoice \(invoice.number ?? "")"
        document.info.author = invoice.business?.name ?? "-"

        // Title Section
        let attributedTitle = NSMutableAttributedString(string: invoice.type?.label ?? "-", attributes: [.font: UIFont.systemFont(ofSize: .init(30), weight: .bold)])
        let attributedNumber = NSMutableAttributedString(string: "شماره فاکتور:  " + (invoice.number?.toPersian() ?? "-"),
                                                         attributes: [
                                                             .font: UIFont.systemFont(ofSize: .init(12)),
                                                         ])
        let attributedDate = NSMutableAttributedString(string: "تاریخ صدور:  " + formattedDate(invoice.date ?? .now),
                                                       attributes: [
                                                           .font: UIFont.systemFont(ofSize: .init(12)),
                                                       ])
        let attributedDueDate = NSMutableAttributedString(string: "تاریخ سررسید:  " + formattedDate(invoice.dueDate ?? .now),
                                                          attributes: [
                                                              .font: UIFont.systemFont(ofSize: .init(12)),
                                                          ])

        document.add(.headerRight, attributedText: attributedTitle)

        document.add(.headerLeft, attributedText: attributedNumber)
        document.add(.headerLeft, attributedText: attributedDate)
        if let options = invoice.options, options.contains(.dueDate) {
            document.add(.headerLeft, attributedText: attributedDueDate)
        }

        document.add(space: 20)

        let comma = NSMutableAttributedString(string: "  ,  ", attributes: [:])

        // Customer Information
        let customerDetailsTable = PDFTable(rows: 1, columns: 1)
        customerDetailsTable.padding = 10

        guard let name = invoice.customer?.name, !name.isEmpty else {
            print("Error generating PDF: Customer name is empty")
            return nil
        }

        let customerDetails = NSMutableAttributedString()
        customerDetails.append(createAttributedString(label: "خریدار", value: name))

        if let phone = invoice.customer?.phone, !phone.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "تلفن", value: phone.filter { $0.isNumber }.toPersian()))
        }

        if let email = invoice.customer?.email, !email.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "ایمیل", value: email))
        }

        if let address = invoice.customer?.address, !address.isEmpty {
            customerDetails.append(comma)
            customerDetails.append(createAttributedString(label: "آدرس", value: address))
        }

        customerDetailsTable[0, 0].content = try? PDFTableContent(content: customerDetails)
        customerDetailsTable[row: 0].allCellsAlignment = .right
        customerDetailsTable.style = PDFTableStyle(
            outline: PDFLineStyle(type: .full, color: systemGray5, width: 1),
            columnHeaderStyle: PDFTableCellStyle(colors: (fill: systemGray6, text: UIColor.black)),
        )

        document.add(table: customerDetailsTable)
        document.add(space: 10)

        // Items Table
        let table = createItemsTable()
        document.add(table: table)
        document.add(space: 20)

        // Notes and Terms
        document.add(.contentRight, text: "توضیحات:")
        document.add(.contentRight, text: invoice.note ?? "")

        // Business Details
        let businessDetails = NSMutableAttributedString()
        businessDetails.append(createAttributedString(label: "فروشنده", value: invoice.business?.name ?? "-"))

        businessDetails.append(comma)
        businessDetails.append(createAttributedString(label: "تلفن", value: invoice.business?.phone ?? "-"))

        if let website = invoice.business?.website, !website.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "وب سایت", value: website))
        }

        if let email = invoice.business?.email, !email.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "ایمیل", value: email))
        }

        if let address = invoice.business?.address, !address.isEmpty {
            businessDetails.append(comma)
            businessDetails.append(createAttributedString(label: "آدرس", value: address))
        }

        document.add(.footerCenter, attributedText: businessDetails)
        document.add(.footerCenter, space: 10)
        document.addLineSeparator(.footerCenter, style: PDFLineStyle(type: .full, color: UIColor.lightGray, width: 1))

        // Generate PDF
        let generator = TPPDF.PDFGenerator(document: document)
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(invoice.number ?? "invoice").pdf")
        do {
            try generator.generate(to: tempURL)
            return tempURL
        } catch {
            print("Error generating PDF: \(error)")
            return nil
        }
    }

    private func createItemsTable() -> PDFTable {
        let colors = (fill: systemGray6, text: UIColor.black)
        let border = PDFLineStyle(type: .full, color: .lightGray, width: 1)
        let headerStyle = PDFTableCellStyle(colors: colors, borders: PDFTableCellBorders(top: border), font: .systemFont(ofSize: 14))
        let contentStyle = PDFTableCellStyle(borders: PDFTableCellBorders(top: border, right: border), font: .systemFont(ofSize: 12))
        let rowsCounter = (invoice.items ?? []).count + 5
        let table = PDFTable(rows: rowsCounter, columns: 5)
        table.style = PDFTableStyle(
            outline: PDFLineStyle(type: .full, color: systemGray5, width: 1),
            rowHeaderStyle: contentStyle,
            columnHeaderStyle: headerStyle,
            contentStyle: contentStyle,
        )
        table.widths = [0.25, 0.25, 0.1, 0.3, 0.1]
        table.padding = 5

        // Table Headers
        table[0, 0].content = try? PDFTableContent(content: "قیمت کل (\(invoice.currency?.label ?? "-"))")
        table[0, 1].content = try? PDFTableContent(content: "قیمت واحد (\(invoice.currency?.label ?? "-"))")
        table[0, 2].content = try? PDFTableContent(content: "تعداد")
        table[0, 3].content = try? PDFTableContent(content: "نام محصول")
        table[0, 4].content = try? PDFTableContent(content: "ردیف")

        // Table Content
        for (index, item) in (invoice.items ?? []).enumerated() {
            let row = index + 1
            table[row, 0].content = try? PDFTableContent(content: formattedNumber(item.total(in: invoice.currency ?? Currency.IRR)))
            table[row, 1].content = try? PDFTableContent(content: formattedNumber(item.productPrice(in: invoice.currency ?? Currency.IRR)))
            table[row, 2].content = try? PDFTableContent(content: formattedNumber(item.quantity ?? 0))
            table[row, 3].content = try? PDFTableContent(content: item.productName)
            table[row, 4].content = try? PDFTableContent(content: formattedNumber(row))
        }

        // Summary Section
        let netTotalRow = (invoice.items ?? []).count + 1
        table[netTotalRow, 0].content = try? PDFTableContent(content: "\(formattedNumber(invoice.total))")
        table[netTotalRow, 1].content = try? PDFTableContent(content: "جمع کل (\(invoice.currency?.label ?? "-"))")
        table[rows: netTotalRow, columns: 1 ... 4].merge()
        table[netTotalRow, 1].style = headerStyle

        let vatRow = netTotalRow + 1
        table[vatRow, 0].content = try? PDFTableContent(content: "+\(formattedNumber(invoice.vatAmount))")
        table[vatRow, 1].content = try? PDFTableContent(content: formattedNumber((invoice.vat ?? 0) * 100) + " %")
        table[vatRow, 2].content = try? PDFTableContent(content: "ارزش افزوده")
        table[rows: vatRow, columns: 2 ... 4].merge()
        table[vatRow, 2].style = headerStyle

        let discountRow = vatRow + 1
        table[discountRow, 0].content = try? PDFTableContent(content: "-\(formattedNumber(invoice.discountAmount))")
        table[discountRow, 1].content = try? PDFTableContent(content: formattedNumber((invoice.discount ?? 0) * 100) + " %")
        table[discountRow, 2].content = try? PDFTableContent(content: "تخفیف")
        table[rows: discountRow, columns: 2 ... 4].merge()
        table[discountRow, 2].style = headerStyle

        let totalRow = discountRow + 1
        table[totalRow, 0].content = try? PDFTableContent(content: "\(formattedNumber(invoice.totalWithDiscount))")
        table[totalRow, 1].content = try? PDFTableContent(content: "مبلغ نهایی (\(invoice.currency?.label ?? "-"))")
        table[rows: totalRow, columns: 1 ... 4].merge()
        table[totalRow, 0].style = PDFTableCellStyle(borders: PDFTableCellBorders(top: border, right: border), font: .systemFont(ofSize: 14, weight: .bold))
        table[totalRow, 1].style = PDFTableCellStyle(colors: colors, borders: PDFTableCellBorders(top: border), font: .systemFont(ofSize: 14, weight: .bold))

        return table
    }

    private func createAttributedString(label: String, value: String) -> NSMutableAttributedString {
        let bold: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold)]

        let label = NSMutableAttributedString(string: "\(label): ", attributes: bold)
        let value = NSMutableAttributedString(string: value, attributes: [:])
        label.append(value)
        return label
    }

    // Helper Functions
    private func formattedDate(_ date: Date) -> String {
        var formatStyle = Date.FormatStyle.dateTime
        formatStyle.locale = Locale(identifier: "fa")
        formatStyle.calendar = Calendar(identifier: .persian)

        return date.formatted(formatStyle)
    }

    private func formattedNumber(_ input: Int) -> String {
        return input.formatted(.number.grouping(.automatic).locale(Locale(identifier: "fa")))
    }

//    private func formattedNumber(_ input: Decimal) -> String {
//        return input.formatted(.number.grouping(.automatic).locale(Locale(identifier: "fa")))
//    }

    private func formattedNumber(_ input: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fa")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "٬" // U+066C ARABIC THOUSANDS SEPARATOR
        formatter.decimalSeparator = "." // U+066B ARABIC DECIMAL SEPARATOR
        return formatter.string(from: input as NSDecimalNumber) ?? "\(input)"
    }

    //    private func symbol(of code: String) -> String {
    //        let locale = NSLocale(localeIdentifier: code)
    //        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? code
    //    }
}
