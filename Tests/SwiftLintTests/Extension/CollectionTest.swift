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
            case "1":
                XCTAssertEqual(v.count, 4)
            default:
                XCTAssertTrue(false)
            }
        }
    }
    
}
