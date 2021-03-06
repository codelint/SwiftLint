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
    
    static func from (_ from: String, format: String? = nil, zone: Locale? = nil) -> Date? {
        let src = from.replace(search: "\\.[0-9]{3,}.*$", with: "").replace(search: "[a-zA-Z]", with: " ")
        var fmt: String? = format
        if fmt == nil {
            if src.match(regex: "[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}") {
                fmt = "YYYY-MM-dd HH:mm:ss"
            }
            
            if src.match(regex: "[0-9]{1,4}-[0-9]{2}-[0-9]{2}") {
                fmt = "YYYY-MM-dd"
            }
        }
        
        if let f = fmt {
            let formatter = DateFormatter()
            if let z = zone {
                formatter.locale = z
            }
            formatter.dateFormat = f
            let date = formatter.date(from: src)
            return date
        }else{
            return nil
        }
        
    }
    
    var datetimeString: String {
        return self.string(format: "YYYY-MM-dd HH:mm:ss")
    }
    
    var dateString: String {
        return self.string(format: "YYYY-MM-dd")
    }
    
    var iso8601: String {
        return self.string(format: "YYYY-MM-dd HH:mm:ss")
    }
    
    var isoDate: String {
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
    
    var month: Int {
        return Int(self.string(format: "MM"))!
    }
    
    var year: Int {
        return Int(self.string(format: "YYYY"))!
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
    
    func hours(to: Date) -> Int {
        return abs(to.int - self.int)/3600
    }
    
    func minutes(to: Date) -> Int {
        return abs(to.int - self.int)/60
    }
    
    func seconds(to: Date) -> Int {
        return abs(to.int - self.int)
    }
    
    func days(to: Date) -> Int {
        if let end = Date.from(to.string(format: "YYYY-MM-dd 00:00:00")), let start = Date.from(self.string(format: "YYYY-MM-dd 00:00:00")) {
            return (abs(end.int - start.int))/86400
        }else{
            return 0
        }
        // return (abs(Date.from(to.string(format: "YYYY-MM-dd 00:00:00")).int - Date.from(self.string(format: "YYYY-MM-dd 00:00:00")).int))/86400
    }
}
