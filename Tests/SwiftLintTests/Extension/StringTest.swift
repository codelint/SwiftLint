//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import XCTest
@testable import SwiftLint

class StringTests: XCTestCase {
    
    func testEnds() {
        XCTAssertTrue("hello world!!!".ends(with: "!!!"))
        XCTAssertFalse("hello world!!!".ends(with: "bbd"))
        XCTAssertTrue("hello world!!!".ends(with: ["bbd", "!!"]))
        XCTAssertFalse("hello world!!!".ends(with: []))
    }
    
    func testStarts() {
        XCTAssertTrue("hello world!!!".starts(with: ["hello", "!!"]))
        XCTAssertFalse("hello world!!!".starts(with: []))
        XCTAssertFalse("hello world!!!".starts(with: ["eee", "!!"]))
    }
    
    func testMatch() {
        XCTAssertTrue("hello world!!!".match(regex: ".*"))
        XCTAssertTrue("hello world!!!".match(regex: "^[a-zA-Z ]*!!!$"))
        XCTAssertTrue("hello world!!!".match(regex: "[a-zA-Z ]*!!!"))
        XCTAssertFalse("hello world!!!".match(regex: "[a-zA-Z]*!!!"))
        XCTAssertFalse("hello world!!!".match(regex: "hello"))
    }
    
    
    
}
