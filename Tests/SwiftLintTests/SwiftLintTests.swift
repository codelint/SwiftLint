import XCTest
@testable import SwiftLint

final class SwiftLintTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftLint().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
