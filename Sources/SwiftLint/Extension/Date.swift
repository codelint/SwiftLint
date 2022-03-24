//
//  Date.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

public extension Date {
    
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
    
    func string(format: String = "YYYY-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
