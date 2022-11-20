import XCTest
@testable import SwiftSpirit

final class SwiftSpiritTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftSpirit().text, "Hello, World!")

        let s = "💖abcdef" | "dsdsds"
        print(s.index(s.startIndex, offsetBy: 1).encodedOffset)
        print(s.utf8.index(s.utf8.startIndex, offsetBy: 4).encodedOffset)
        print(s.utf8.index(s.utf8.startIndex, offsetBy: 4).utf16Offset(in: s))
    }
}
