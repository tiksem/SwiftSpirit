//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation
import XCTest
@testable import SwiftSpirit

public class AnyCharRuleTests : XCTestCase {
    func testParse() {
        let str = "a"
        XCTAssertEqual(char.compile().tryParse(string: str), str.index(after: str.startIndex))
    }

    func testParse2() {
        let str = "awerr"
        XCTAssertEqual(char.compile().tryParse(string: str), str.index(after: str.startIndex))
    }

    func testParseWithResult() {
        let str = "a"
        let result = char.compile().parseWithResult(string: str)
        XCTAssertEqual(result.result, "a")
        XCTAssertEqual(result.state.seek, str.index(after: str.startIndex))
    }

    func testParseWithResult2() {
        let str = "adsdsds"
        let result = char.compile().parseWithResult(string: str)
        XCTAssertEqual(result.result, "a")
        XCTAssertEqual(result.state.seek, str.index(after: str.startIndex))
    }

    func testParseEof() {
        let str = ""
        let result = char.compile().parseWithResult(string: str)
        XCTAssertEqual(result.state.code, .eof)
        XCTAssertEqual(result.state.seek, str.startIndex)

        XCTAssertEqual(char.compile().tryParse(string: str), nil)
    }

    func testNo() {
        let str = "2"
        let result = (!char).compile().parseWithResult(string: str)
        XCTAssertEqual(result.state.code, .noFailed)
        XCTAssertEqual(result.state.seek, str.startIndex)
    }

    func testNoEof() {
        let str = ""
        let result = (!char).compile().parseWithResult(string: str)
        XCTAssertEqual(result.state.code, .complete)
        XCTAssertEqual(result.state.seek, str.startIndex)
    }
}