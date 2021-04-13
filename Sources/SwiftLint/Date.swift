//
//  Date.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

extension Date {
    var datetimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
}
