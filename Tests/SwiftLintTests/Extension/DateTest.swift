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
        XCTAssertEqual(Date.from("2022-03-24 22:23:38", zone: Locale(identifier: "zh_CN"))?.month, 3)
        XCTAssertEqual(Date.from("2022-11-24 22:23:38", zone: Locale(identifier: "zh_CN"))?.month, 11)
        XCTAssertEqual(Date.from("1986-11-24 22:23:38", zone: Locale(identifier: "zh_CN"))?.year, 1986)
        XCTAssertEqual(Date.from("111-11-24 22:23:38", zone: Locale(identifier: "zh_CN"))?.year, 111)
    }
    
    func testDateString() {
        XCTAssertEqual("2022-03-24 22:23:38", Date(timeIntervalSince1970: 1648131818).string(format: "YYYY-MM-dd HH:mm:ss", zone: Locale(identifier: "zh_CN")))
    }
    
    func testDateFrom() {
        // 1648131359861
        // zh_CN
        XCTAssertEqual(1648131818, Date.from("2022-03-24 22:23:38", zone: Locale(identifier: "zh_CN"))?.int)
        // 2022-03-23T17:56:28.268Z
        XCTAssertEqual(1648029388, Date.from("2022-03-23T17:56:28.268Z",zone: Locale(identifier: "zh_CN"))?.int)
        XCTAssertEqual(1648051200, Date.from("2022-03-24", zone: Locale(identifier: "zh_CN"))?.int)
        
    }
    
    func testDays() {
        if let to = Date.from("1986-09-08 23:23:11"), let from = Date.from("1986-09-09 00:00:01") {
            XCTAssertEqual(1, from.days(to: to))
        }
        
        if let to = Date.from("2022-03-24 22:37:00"), let from = Date.from("1986-09-08 00:00:01") {
            XCTAssertEqual(12981, from.days(to: to))
        }
        
    }
    
//    func test24Hours() {
//        XCTAssertEqual("", Date().string("))
//    }
    
    func testLunar() {
        if let spring = Date.from("2023-01-22 00:00:00") {
            XCTAssertEqual(1, spring.lunarDayInt)
            XCTAssertEqual(spring, spring.moon_date)
            XCTAssertEqual(Date(int: 1679124777).lunarDayInt, 27)
             // XCTAssertEqual((Date(int: 1679124777).moon_date.int - spring.moon_date.int)/86400, 30)
            XCTAssertEqual(Date(int: 1679124777).lunarMonths(since: spring), 1)
        }
    }
    
    func testToday() {
        let date = Date(int: 86400*13 + 1800)
        
        XCTAssertEqual(date.todayAt(86400+3600), Date(int: date.int + 1800))
    }
    
}
