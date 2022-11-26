//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation
import XCTest
@testable import SwiftSpirit

class FloatTest<T : BinaryFloatingPoint> {
    let f = FloatRule<T>(name: "float").compile()
    let no = (!FloatRule<T>(name: "float")).compile()

    func testInteger() {
        let str = "23423453453456543435453"
        XCTAssertEqual(
            f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerWithDot() {
        let str = "23423453453456543435453."
        XCTAssertEqual(
            f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithDotAndDigits() {
        let str = "23423453453456543435453.2322332"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithE() {
        let str = "23423453453456543435453.2322332e122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercase() {
        let str = "23423453453456543435453.2322332E122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithENegative() {
        let str = "23423453453456543435453.2322332e-122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercaseNegative() {
        let str = "23423453453456543435453.2322332E-122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEPlus() {
        let str = "23423453453456543435453.2322332e+122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercasePlus() {
        let str = "23423453453456543435453.2322332E+122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithENoFraction() {
        let str = "23423453453456543435453.e122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercaseNoFraction() {
        let str = "23423453453456543435453.E122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithENegativeNoFraction() {
        let str = "23423453453456543435453.e-122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercaseNegativeNoFraction() {
        let str = "23423453453456543435453.E-122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEPlusNoFraction() {
        let str = "23423453453456543435453.e+122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testFloatWithEUppercasePlusNoFraction() {
        let str = "23423453453456543435453.E+122"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerWithE() {
        let str = "23423453453456543435453e5"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerWithENegative() {
        let str = "23423453453456543435453e-5"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerWithEUppercase() {
        let str = "23423453453456543435453E5"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerWithENegativeUppercase() {
        let str = "23423453453456543435453E-5"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerNegative() {
        let str = "-23423453453456543435453"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testIntegerPlus() {
        let str = "+23423453453456543435453"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func startedWithDot() {
        let str = ".4343343434"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func startedWithDotE() {
        let str = ".4343343434e345"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func startedWithDotEnegative() {
        let str = ".4343343434e-345"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func notMoreDot() {
        let str = ".4343343.56677"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.index(str.startIndex, offsetBy: ".4343343".count), code: .complete)
        )
    }
    
    
    func startsWithDotAndMinus() {
        let str = "-.4343343"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func startsWithDotAndPlus() {
        let str = "+.4343343"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.endIndex, code: .complete)
        )
    }
    
    
    func testMinusDotError() {
        let str = "-."
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }
    
    
    func testMinusDotError2() {
        let str = "-.dhfgdhg"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }
    
    
    func testMinusError() {
        let str = "-"
        XCTAssertEqual(
                f.parse(string: str), ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    func testSpaceAfterFloat() {
        let str = "5.0  "
        let result = f.parseWithResult(string: str)
        XCTAssertEqual(result.result ?? -1.0, 5.0)
        XCTAssertEqual(result.state, ParseState(seek: str.index(str.endIndex, offsetBy: -2), code: .complete))
    }

    func notMoreDotError() {
        let str = ".."
        XCTAssertEqual(
            f.parse(string: str), ParseState(seek: str.startIndex, code: .invalidFloat)
        )
    }

    func noParseTest() {
        let str = "......."
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    
    func noParseTest3() {
        let str = "abcdegfrt9.0"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    
    func noParseTest4() {
        let str = "+__fff.0"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    
    func noParseTest5() {
        let str = "-__fff"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    
    func noParseTest6() {
        let str = "+.er4"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    
    func noParseTest7() {
        let str = "-.er4"
        XCTAssertEqual(no.tryParse(string: str), str.index(after: str.startIndex))
    }
    
    func test() {
        testInteger()
        testIntegerWithDot()
        testFloatWithDotAndDigits()
        testFloatWithE()
        testFloatWithEUppercase()
        testFloatWithENegative()
        testFloatWithEUppercaseNegative()
        testFloatWithEPlus()
        testFloatWithEUppercasePlus()
        testFloatWithENoFraction()
        testFloatWithEUppercaseNoFraction()
        testFloatWithENegativeNoFraction()
        testFloatWithEUppercaseNegativeNoFraction()
        testFloatWithEPlusNoFraction()
        testFloatWithEUppercasePlusNoFraction()
        testIntegerWithE()
        testIntegerWithENegative()
        testIntegerWithEUppercase()
        testIntegerWithENegativeUppercase()
        testIntegerNegative()
        testIntegerPlus()
        startedWithDot()
        startedWithDotE()
        startedWithDotEnegative()
        notMoreDot()
        startsWithDotAndMinus()
        startsWithDotAndPlus()
        testMinusDotError()
        testMinusDotError2()
        testMinusError()
        testSpaceAfterFloat()
        notMoreDotError()
        noParseTest()
        noParseTest3()
        noParseTest4()
        noParseTest5()
        noParseTest6()
        noParseTest7()
    }
}

class FloatTests : XCTestCase {
    func testFloat() {
        FloatTest<Float>().test()
    }

    func testDouble() {
        FloatTest<Double>().test()
    }
}