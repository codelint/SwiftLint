//
//  Date.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

public extension Date {
    
//    static let FMT_ISO = "YYYY-MM-dd HH:mm:ss"
//    static let FMT_ISO_DATE = "YYYY-MM-dd"
    
    static func from (_ from: String, format: String = "YYYY-MM-dd HH:mm:ss", zone: Locale? = nil) -> Date {
        let formatter = DateFormatter()
        if let z = zone {
            formatter.locale = z
        }
        formatter.dateFormat = format
        let date = formatter.date(from: from)
        return date!
    }
    
    var datetimeString: String {
        return self.string(format: "YYYY-MM-dd HH:mm:ss")
    }
    
    var dateString: String {
        return self.string(format: "YYYY-MM-dd")
    }
    
    var int64: Int64 {
        Int64(self.timeIntervalSince1970)
    }
    
    var int32: Int32 {
        Int32(self.timeIntervalSince1970)
    }
    
    var int: Int {
        Int(self.timeIntervalSince1970)
    }
    
    func string(format: String = "YYYY-MM-dd HH:mm:ss", zone: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = format
        if let z = zone {
            formatter.locale = z
        }
        return formatter.string(from: self)
    }
    
    func days(to: Date) -> Int {
        return (abs(Date.from(to.string(format: "YYYY-MM-dd 00:00:00")).int - Date.from(self.string(format: "YYYY-MM-dd 00:00:00")).int) + 1)/86400
    }
}
