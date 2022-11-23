import XCTest
@testable import SwiftSpirit

final class SwiftSpiritTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftSpirit().text, "Hello, World!")

        let s = "💖abcdef" | "dsdsds"
    }
}
