import Foundation
import XCTest
@testable import SwiftSpirit

private let no = (!decimal).compile()

public class DecimalTest : XCTestCase {
    func testInteger() {
        let str = "23423453453456543435453"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerWithDot() {
        let str = "23423453453456543435453."
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithDotAndDigits() {
        let str = "23423453453456543435453.2322332"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithE() {
        let str = "23423453453456543435453.2322332e122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercase() {
        let str = "23423453453456543435453.2322332E122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithENegative() {
        let str = "23423453453456543435453.2322332e-122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercaseNegative() {
        let str = "23423453453456543435453.2322332E-122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEPlus() {
        let str = "23423453453456543435453.2322332e+122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercasePlus() {
        let str = "23423453453456543435453.2322332E+122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithENoFraction() {
        let str = "23423453453456543435453.e122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercaseNoFraction() {
        let str = "23423453453456543435453.E122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithENegativeNoFraction() {
        let str = "23423453453456543435453.e-122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercaseNegativeNoFraction() {
        let str = "23423453453456543435453.E-122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEPlusNoFraction() {
        let str = "23423453453456543435453.e+122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testDoubleWithEUppercasePlusNoFraction() {
        let str = "23423453453456543435453.E+122"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerWithE() {
        let str = "23423453453456543435453e5"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerWithENegative() {
        let str = "23423453453456543435453e-5"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerWithEUppercase() {
        let str = "23423453453456543435453E5"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerWithENegativeUppercase() {
        let str = "23423453453456543435453E-5"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerNegative() {
        let str = "-23423453453456543435453"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testIntegerPlus() {
        let str = "+23423453453456543435453"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func startedWithDot() {
        let str = ".4343343434"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func startedWithDotE() {
        let str = ".4343343434e345"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func startedWithDotEnegative() {
        let str = ".4343343434e-345"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func notMoreDot() {
        let str = ".4343343.56677"

        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(
                seek: str.index(str.startIndex, offsetBy: ".4343343".count),
                code: .complete
            )
        )
    }

    func startsWithDotAndMinus() {
        let str = "-.4343343"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func startsWithDotAndPlus() {
        let str = "+.4343343"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }

    func testMinusDotError() {
        let str = "-."
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    func testMinusDotError2() {
        let str = "-.dhfgdhg"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    func testMinusError() {
        let str = "-"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    private func testResult(_ string: String) {
        XCTAssertEqual(
            try! decimal.compile().parseValueOrThrow(string: string),
            Decimal(string: string)
        )
    }

    func testResults() {
        testResult("23423453453456543435453E-5")
        testResult("23423453453456543435453e-5")
        testResult("-23423453453456543435453e-5")
        testResult("35237856237485623478562348756234785623478562347856234785623478562347856234758")
        testResult("-35237856237485623478562348756234785623478562347856234785623478562347856234758")
        testResult("+35237856237485623478562348756234785623478562347856234785623478562347856234758")
        testResult("+35237856237485623478562348756234785623478562347856234785623478562347856234758E4")
        testResult("+35237856237485623478562348756234785623478562347856234785623478562347856234758e4")
    }

    func largeExponent() {
        let str = "+35237856237485623478562348756234785623478562347856234785623478562347856234758e4343323232"
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(seek: str.startIndex, code: .decimalOverflow)
        )
    }

    func testSpaceAfterDouble() {
        let str = "5.0  "
        XCTAssertEqual(
            decimal.parseWithResult(seek: str.startIndex, string: str),
            ParseResult<Decimal>(
                seek: str.index(str.startIndex, offsetBy: "5.0".count),
                code: .complete,
                result: Decimal(string: "5.0")
            )
        )
    }

    func testNotMoreDotError() {
        let str = "..."
        XCTAssertEqual(
            decimal.parse(seek: str.startIndex, string: str),
            ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    func testNoParse() {
        let str = "........"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoPars2() {
        let str = "abcdegfrt9.0"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoParse3() {
        let str = "+__fff.0"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoParse4() {
        let str = "-__fff"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoParse5() {
        let str = "-__fff"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoParse6() {
        let str = "+.er4"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }

    func testNoParse7() {
        let str = "-.er4"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
}
