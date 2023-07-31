//
//  LangTest.swift
//  
//
//  Created by gzhang on 2022/11/11.
//

import XCTest
@testable import SwiftLint

final class LangTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOptionalLet() throws {
        let a: Int? = nil
        let notNil: Int? = 3
        a.with { a in
            XCTAssertTrue(false)
        }
        notNil.with { a in
            XCTAssertEqual(a, 3)
        }
        
    }
    
    func testIntLPad() throws {
        XCTAssertEqual((-1).lpad(2), "-01")
        XCTAssertEqual(0.lpad(2), "00")
        XCTAssertEqual(2.lpad(2), "02")
        XCTAssertEqual(3.lpad(2), "03")
        XCTAssertEqual(3.lpad(3), "003")
        XCTAssertEqual(315.lpad(10), "0000000315")
    }
    
    

//    func testPerformanceExample() throws {
//
//        self.measure {
//
//        }
//    }

}
