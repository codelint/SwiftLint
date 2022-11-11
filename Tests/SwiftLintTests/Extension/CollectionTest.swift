//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import XCTest
@testable import SwiftLint

class CollectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testArrayContains() {
        let arr = ["a", "b", "c", "i", "love", "ray"]
        
        XCTAssertTrue(arr.contains(elements: ["a"]))
        XCTAssertTrue(arr.contains(elements: ["a", "love"]))
        XCTAssertFalse(arr.contains(elements: ["alove"]))
        XCTAssertFalse(arr.contains(elements: ["a", "alove"]))
    }
    
    func testOnly() {
        let dict = [
            "a": 234,
            "b": 2,
            "c": 33,
            "d": 324
        ]
        
        let actual = dict.only(keys: ["a", "b"])
        
        XCTAssertEqual(actual["a"], dict["a"])
        XCTAssertEqual(actual["b"], dict["b"])
        XCTAssertNil(actual["c"])
        XCTAssertNil(actual["d"])
    }
    
    func testArrayExceptOnly() {
        let dict = ["a", "b", "c", "d"]
        
        let actual = dict.except(elements: ["a", "b"])
        
        XCTAssertEqual(actual.count, 2)
        XCTAssertEqual(actual.joined(separator: ""), "cd")
        
        let only = dict.only(elements: ["a", "b"])
        
        XCTAssertEqual(only.count, 2)
        XCTAssertEqual(only.joined(separator: ""), "ab")
     
    }
    
    func testArrayAsyncEach() {
        // helper.findBy(request: NSFetchRequest<User>)
        let arr = [5, 2, 0, 1, 3, 1, 4]
        var firstE = 0
        var lastE = 0
        
        arr.asyncEach(arr, next: { item, index, next in
            XCTAssertEqual(item, arr[index])
            next()
        }, first: { first, next in
            firstE = first
            next()
        }) { last in
            lastE = last
        }
        XCTAssertEqual(firstE, 5)
        XCTAssertEqual(lastE, 4)
        
        lastE = 0
        firstE = 0
        arr.asyncEach(arr, from: 1, next: { item, index, next in
            XCTAssertTrue(false)
            next()
        }, first: { first, next in
            firstE = first
        }, last: { last in
            lastE = last
        })
        XCTAssertEqual(firstE, 2)
        XCTAssertEqual(lastE, 0)
    }
    
    func testGroupBy() {
        let arr = [5, 2, 0, 1, 3, 1, 4]
        
        let groups = arr.groupBy { e in
            "\(e%2)"
        }
        
        for (k, v) in groups {
            switch(k){
            case "0":
                XCTAssertEqual(v.count, 3)
                XCTAssertEqual(v.sum(), 6)
            case "1":
                XCTAssertEqual(v.count, 4)
                XCTAssertEqual(v.sum(), 10)
            default:
                XCTAssertTrue(false)
            }
        }
    }
    
    func testDictionaryAsyncEach() {
        // helper.findBy(request: NSFetchRequest<User>)
        let arr = ["5", "3", "2", "1"]
        let dict: [String:Int] = [
            "5": 1,
            "3": 2,
            "1": 234,
            "2": 3284728
        ]
        var firstE: Int = 5
        var lastE: Int = 3284728
        
        dict.asyncEach(arr, next: { item, index, next in
            // XCTAssertEqual(item, dict[index])
            next()
        }, first: { fv, fk, next in
            firstE = fv
            next()
        }) { lv, lk in
            lastE = lv
        }
        XCTAssertEqual(firstE, 1)
        XCTAssertEqual(lastE, 234)
        
        lastE = 0
        firstE = 0
        dict.asyncEach(arr, from: 1, next: { item, index, next in
            XCTAssertTrue(false)
            next()
        }, first: { fv,fk, next in
            firstE = fv
        }, last: { lv, lk in
            lastE = lv
        })
        XCTAssertEqual(firstE, 2)
        XCTAssertEqual(lastE, 0)
    }
    
    func testDictionryLoop(){
        let dict: [String:Int] = [
            "5": 1,
            "3": 2,
            "1": 234,
            "2": 3284728
        ]
        
        var v1 = 0
        var v2 = ""
        var count = 0
        dict.loop { i, str, next in
            count += 1
            v1 += i
            v2 = "\(v2)\(str)"
            next?()
        }
        XCTAssertEqual(count, 4)
        XCTAssertEqual(v1, 3284965)
        // XCTAssertEqual(v2, "5312")
    }
    
}
