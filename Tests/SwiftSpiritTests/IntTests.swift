import XCTest
@testable import SwiftSpirit

final class IntTest<T : FixedWidthInteger & SignedInteger> {
    let rule: IntRule<T>
    let r: BaseParser<T>

    init(rule: IntRule<T>) {
        self.rule = rule
        self.r = rule.compile()
    }

    func testStartedWithZero() throws {
        do {
            try r.parseValueOrThrow(string: "03")
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
        try XCTAssertEqual(-34, r.parseValueOrThrow(string: "-34"))
    }
    
    
    func testPlus() throws {
        try XCTAssertEqual(+34, r.parseValueOrThrow(string: "+34"))
    }
    
    func testDefault() throws {
        try XCTAssertEqual(23, r.parseValueOrThrow(string: "23"))
    }

    func testOutOfRange() throws {
        let res = r.parseWithResult(string: T.max.description + "0")
        XCTAssertEqual(.intOverflow, res.state.code)
    }

    func testInvalid() throws {
        let res = r.parseWithResult(string: "dsds67")
        XCTAssertEqual(.invalidInt, res.state.code)
    }
    
    func testNoInt() throws {
        let r = (!rule).compile()
        XCTAssertEqual(r.matchesAtBeginning(string: "+dsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "-dsdsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "dsdsds"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "-"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "+"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "+4"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "-0"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "0"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "0345"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: "100"), false)
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
        XCTAssertEqual(r.matchesAtBeginning(string: "034"), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "100"), true)
        XCTAssertEqual(r.matchesAtBeginning(string: ""), false)
        XCTAssertEqual(r.matchesAtBeginning(string: "100rror"), true)
    }

    func test() throws {
        try testStartedWithZero()
        try testZero()
        try testMinusZero()
        try testPlusZero()
        try testMinus()
        try testPlus()
        try testDefault()
        try testInvalid()
        try testNoInt()
        try testIntMatches()
    }
}

final class IntTests : XCTestCase {
    func test() throws {
        try IntTest(rule: int8).test()
        try IntTest(rule: int16).test()
        try IntTest(rule: int32).test()
        try IntTest(rule: int64).test()
        try IntTest(rule: int).test()
    }
}


