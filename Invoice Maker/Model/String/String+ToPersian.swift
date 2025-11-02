//
//  String+ToPersian.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 31/12/2024.
//

import Foundation

extension String {
    func toPersian() -> String {
        let numbersDictionary: Dictionary = ["0": "۰", "1": "۱", "2": "۲", "3": "۳", "4": "۴", "5": "۵", "6": "۶", "7": "۷", "8": "۸", "9": "۹"]
        var str: String = self
        
        for (key, value) in numbersDictionary {
            str = str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
}
