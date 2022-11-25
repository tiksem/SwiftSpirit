import XCTest
@testable import SwiftSpirit

final class IntTests: XCTestCase {
    let r = int.compile()
    
    func testStartedWithZero() throws {
        do {
            try r.parseValueOrThrow(string: "034534554")
        } catch ParseError.intStartedFromZero(let seek) {
        }
    }
    
    func testZero() throws {
        try XCTAssertEqual(0, r.parseValueOrThrow(string: "0"))
    }
    
    
    func testMinusZero() throws {
        try XCTAssertEqual(0, r.parseValueOrThrow(string: "-0"))
    }
    
    
    func testPlusZero() throws {
        try XCTAssertEqual(0, r.parseValueOrThrow(string: "+0"))
    }
    
    
    func testMinus() throws {
        try XCTAssertEqual(-345, r.parseValueOrThrow(string: "-345"))
    }
    
    
    func testPlus() throws {
        try XCTAssertEqual(+345, r.parseValueOrThrow(string: "+345"))
    }
    
    
    func testDefault() throws {
        try XCTAssertEqual(23523454, r.parseValueOrThrow(string: "23523454"))
    }
    
    
    func testOutOfRange() throws {
        let res = r.parseWithResult(string: Int.max.description + "0")
        XCTAssertEqual(.intOverflow, res.state.code)
    }
    
    
    func testInvalid() throws {
        let res = r.parseWithResult(string: "dsds65537")
        XCTAssertEqual(.invalidInt, res.state.code)
    }
    
    
    func testNoInt() throws {
        let r = (!int).compile()
        XCTAssertEqual(r.matchesAtBeginning(string: "+dsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "-dsdsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "dsdsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "-"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "+"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "+4"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "-0"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "0"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "0345"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "456"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: ""), true)
    }

    func testIntMatches() throws {
        XCTAssertEqual(r.matchesAtBeginning(string: "+dsds"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "-dsdsds"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "dsdsds"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "-"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "+"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "+4"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "-0"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "0"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "0345"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "456"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: ""), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "3434rror"), true)
    }
}
