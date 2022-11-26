//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation
import XCTest
@testable import SwiftSpirit

public class ExactStringTests :  XCTestCase {
    func testEmpty() throws {
        XCTAssertEqual(try str("").compile().parseValueOrThrow(string: ""), "")
    }

    func testSome() throws {
        XCTAssertEqual(try str("some").compile().parseValueOrThrow(string: "some"), "some")
    }

    func testSomeRepeat() throws {
        XCTAssertEqual(
                try str("some")*.compile().parseValueOrThrow(string: "somesomesome"),
                ["some", "some", "some"]
        )
    }

    func testNo() throws {
        let r = !str("some")
        XCTAssertEqual(r.compile().tryParse(string: "some"), nil)
        XCTAssertEqual(r.compile().tryParse(string: "somefddffd"), nil)
        var str = "dsdsdssome"
        XCTAssertEqual(r.compile().tryParse(string: str), str.index(after: str.startIndex))
        str = ""
        XCTAssertEqual(r.compile().tryParse(string: str), str.endIndex)
    }
}
