//
//  File.swift
//  
//
//  Created by gzhang on 2023/12/17.
//

import XCTest
@testable import SwiftLint

class LintExpressionTests: XCTestCase {
    
    func testEvaluate1() {
        let expression = LintExpression("1(")
        let tokens = expression.split2tokens()
        XCTAssertEqual(tokens, ["(", "1", "(", ")"])
        XCTAssertEqual(expression.evaluate()?.toFixed(1), "1.0")
    }
    
    func testEvaluate2() {
        let expression = LintExpression(")1+3")
        let tokens = expression.split2tokens()
        XCTAssertEqual(tokens, ["(", ")", "1", "+", "3", ")"])
        XCTAssertEqual(expression.evaluate()?.toFixed(1), "4.0")
        XCTAssertNil(LintExpression("2342341+3+-*").evaluate())
    }
    
    func testEvaluate() {
        
        let expression = LintExpression("0 - 10 + 100")
        let tokens = expression.split2tokens()
        XCTAssertEqual(tokens, ["(", "0", "-", "10", "+", "100", ")"])
        
        if let result = LintExpression("0 - 10 + 100").evaluate() {
            XCTAssertEqual(result.toFixed(4), "90.0000")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("(0 - 10)*100 + 100").evaluate() {
            XCTAssertEqual(result.toFixed(0), "-900")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("1 - 10 + 5").evaluate() {
            XCTAssertEqual(result.toFixed(4), "-4.0000")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("1 - 2 + 7").evaluate() {
            XCTAssertEqual(result.toFixed(4), "6.0000")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("1 + 2/8").evaluate() {
            XCTAssertEqual(result.toFixed(4), "1.2500")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("1 - 2 + 7 + 2/8").evaluate() {
            XCTAssertEqual(result.toFixed(4), "6.2500")
        }else{
            XCTFail()
        }
        
        if let result = LintExpression("0/(3+2)").evaluate() {
            XCTAssertEqual(result.toFixed(4), "0.0000")
        }else{
            XCTFail()
        }
        
        XCTAssertNil(LintExpression("1/0.0").evaluate())
        XCTAssertNil(LintExpression(")1/0.0").evaluate())
        // XCTAssertNil(LintExpression("1").evaluate())
//        if let result = LintExpression("1/10*100").evaluate() {
//            XCTAssertEqual(result.toFixed(4), "90.0000")
//        }else{
//            XCTFail()
//        }
        
    }
}
