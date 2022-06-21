//
//  String + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation

extension String {
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "EEE, dd MMM yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func getYearValue() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "YYYY"
            return "("+formatter.string(from: date)+")"
        } else {
            return ""
        }
    }
}
