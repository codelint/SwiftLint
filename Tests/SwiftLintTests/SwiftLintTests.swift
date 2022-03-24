import XCTest
@testable import SwiftLint

final class SwiftLintTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
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
        
        
        XCTAssertEqual(SwiftLint().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
