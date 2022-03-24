//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import XCTest
@testable import SwiftLint

class DateTests: XCTestCase {
    
    func testMonth() {
        XCTAssertEqual(Date.from("2022-03-24 22:23:38", zone: Locale(identifier: "zh_CN")).month, 3)
        XCTAssertEqual(Date.from("2022-11-24 22:23:38", zone: Locale(identifier: "zh_CN")).month, 11)
        XCTAssertEqual(Date.from("1986-11-24 22:23:38", zone: Locale(identifier: "zh_CN")).year, 1986)
        XCTAssertEqual(Date.from("111-11-24 22:23:38", zone: Locale(identifier: "zh_CN")).year, 111)
    }
    
    func testDateString() {
        XCTAssertEqual("2022-03-24 22:23:38", Date(timeIntervalSince1970: 1648131818).string(format: "YYYY-MM-dd HH:mm:ss", zone: Locale(identifier: "zh_CN")))
    }
    
    func testDateFrom() {
        // 1648131359861
        // zh_CN
        XCTAssertEqual(1648131818, Date.from("2022-03-24 22:23:38", zone: Locale(identifier: "zh_CN")).int)
    }
    
    func testDays() {
        var to = Date.from("1986-09-08 23:23:11")
        var from = Date.from("1986-09-09 00:00:01")
        XCTAssertEqual(1, from.days(to: to))
        
        to = Date.from("2022-03-24 22:37:00")
        from = Date.from("1986-09-08 00:00:01")
        XCTAssertEqual(12981, from.days(to: to))
    }
    
}
