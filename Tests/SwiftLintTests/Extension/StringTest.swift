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
    
    func testReplace() {
        let str = "Who is the girl u love in this world"
        
        XCTAssertEqual("Who is the boy u love in this world", str.replace(search: "girl", with: "boy"))
        XCTAssertEqual("Wh* is the girl * l*ve in this w*rld", str.replace(search: "[ou]", with: "*"))
        XCTAssertEqual("2022-09-08 12:12:12", "1986-09-08 12:12:12".replace(search: "[0-9]{4,}", with: "2022"))
        XCTAssertEqual("2022", "1986-09-08 12:12:12".replace(search: "^.*$", with: "2022"))
        XCTAssertEqual("2022-03-23 17:56:28", "2022-03-23T17:56:28.268Z".replace(search: "\\.[0-9]{3,}.*$", with: "").replace(search: "[a-zA-Z]", with: " "))
    }
    
    
    
}
