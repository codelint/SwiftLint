//
//  Date.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

public extension Date {
    
//    static let FMT_ISO = "yyyy-MM-dd HH:mm:ss"
//    static let FMT_ISO_DATE = "yyyy-MM-dd"
    
    init(int from: any BinaryInteger)
    {
        self = Date(timeIntervalSince1970: TimeInterval(from))
    }
    
    static func from (_ from: String, format: String? = nil, zone: TimeZone? = nil, locale: Locale? = nil) -> Date? {
        let src = from.replace(search: "\\.[0-9]{3,}.*$", with: "").replace(search: "[a-zA-Z]", with: " ")
        var fmt: String? = format
        if fmt == nil {
            if src.match(regex: "[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}") {
                fmt = "yyyy-MM-dd HH:mm:ss"
            }
            
            if src.match(regex: "[0-9]{1,4}-[0-9]{2}-[0-9]{2}") {
                fmt = "yyyy-MM-dd"
            }
        }
        
        if let f = fmt {
            let formatter = DateFormatter()
            if let locale = locale {
                formatter.locale = locale
            }else{
                formatter.locale = .init(identifier: "en_US_POSIX")
            }
            formatter.dateFormat = f
            formatter.timeZone = zone
            let date = formatter.date(from: src)
            return date
        }else{
            return nil
        }
        
    }
    
    var int64: Int64 { Int64(self.timeIntervalSince1970) }
    
    var int32: Int32 { Int32(self.timeIntervalSince1970) }
    
    var int: Int { Int(self.timeIntervalSince1970) }
    
    var month: Int {
        return Int(self.string(format: "MM"))!
    }
    
    var year: Int {
        return Int(self.string(format: "yyyy"))!
    }
    
    var monthInt: Int { Int(self.string(format: "MM"))! }
    
    var yearInt: Int { Int(self.string(format: "yyyy"))! }
    
    /**
     * Sunday is zero
     */
    var weekInt: Int {
        switch self.string(format: "EEE") {
        case "Sun": return 0
        case "Mon": return 1
        case "Tue": return 2
        case "Wed": return 3
        case "Thu": return 4
        case "Fri": return 5
        case "Sat": return 6
        default:
            return Int(self.string(format: "e")) ?? 0
        }
    }
    
    var dayInt: Int { Int(self.string(format: "dd"))! }
    
    var hourInt: Int { Int(self.string(format: "HH")) ?? 0 }
    
    var minuteInt: Int { Int(self.string(format: "mm")) ?? 0 }
    
    var secondInt: Int { Int(self.string(format: "ss")) ?? 0 }
    
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
    
        if let end = Date.from(to.string(format: "yyyy-MM-dd 00:00:00")), let start = Date.from(self.string(format: "yyyy-MM-dd 00:00:00")) {
            return (abs(end.int - start.int))/86400
        }else{
            return 0
        }
        // return (abs(Date.from(to.string(format: "YYYY-MM-dd 00:00:00")).int - Date.from(self.string(format: "YYYY-MM-dd 00:00:00")).int))/86400
    }
    
}

/**
 * Date strings
 */
public extension Date {
    
    func string(format: String = "yyyy-MM-dd HH:mm:ss", zone: TimeZone? = nil, locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = format
        
        if let locale = locale {
            formatter.locale = locale
        }else{
            formatter.locale = .init(identifier: "en_US_POSIX")
        }
        formatter.timeZone = zone
        return formatter.string(from: self)
    }
    
    var datetimeString: String {
        return self.string(format: "yyyy-MM-dd HH:mm:ss")
    }
    
    var dateString: String {
        return self.string(format: "yyyy-MM-dd")
    }
    
    var iso8601: String {
        return self.string(format: "yyyy-MM-dd HH:mm:ss")
    }
    
    var isoDate: String {
        return self.string(format: "yyyy-MM-dd")
    }
    
}

public extension Date {
    
    var YMd: Date { today() ?? self }
    
    func today(time: String = "00:00:00") -> Date? { Date.from(self.string(format: "yyyy-MM-dd \(time)")) }
    
    func todayAt(_ seconds: Int = 0 ) -> Date { Date(int: Date.from(self.string(format: "yyyy-MM-dd 00:00:00"))!.int + seconds) }
}

/**
 * Chinese calenar date
 *
 * -639129600 : 1949-10-01 00:00:00 时间戳
 * 3081600 : 1970年春节0时（中国时间)
 */
public extension Date {
    static let TIMESTAMP_SPRINT_FESTIVAL_1970: Int = 3081600
    static let MOON_DAYS: CGFloat = 29.530588
    
    var lunarDayInt: Int {
        let past = (CGFloat(self.int - Self.TIMESTAMP_SPRINT_FESTIVAL_1970)/86400)/Self.MOON_DAYS
        return Int((past - CGFloat(Int(past)))*Self.MOON_DAYS + 1)
    }
    
    var moon_date: Date { Date(int: self.int - (self.lunarDayInt-1)*86400).YMd }
    
    // Celestial Stem & Terrestrial Stem
    var ctDayInt: Int { ((self.int + 639129600)/86400)%60 }
    
    // not right anytime
    var ctYearInt: Int { (self.yearInt - 1864)%60 }
    
    func lunarMonths(since: Date) -> Int {
        (((self.moon_date.int - since.moon_date.int + 86400).cgfloat/86400)/Self.MOON_DAYS).int
    }
    
    
}
