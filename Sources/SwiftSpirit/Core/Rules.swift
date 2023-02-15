//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

let int = IntRule<Int>(name: "int")
let int8 = IntRule<Int8>(name: "int8")
let int16 = IntRule<Int16>(name: "int16")
let int32 = IntRule<Int32>(name: "int32")
let int64 = IntRule<Int64>(name: "int64")

let uint = UIntRule<UInt>(name: "uint")
let uint8 = UIntRule<UInt8>(name: "uint8")
let uint16 = UIntRule<UInt16>(name: "uint16")
let uint32 = UIntRule<UInt32>(name: "uint32")
let uint64 = UIntRule<UInt64>(name: "uint64")

let float = FloatRule<Float>(name: "float")
let double = FloatRule<Double>(name: "double")
let bigint = BigIntRule()
let biguint = BigUIntRule()
let decimal = DecimalRule()

let char = AnyCharRule()
let character = AnyCharacterRule()

func char(_ ch: UnicodeScalar) -> CharPredicateRule {
    let data = CharPredicateData(matchChar: ch, inverted: false)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(_ chars: UnicodeScalar...) -> CharPredicateRule {
    let data = CharPredicateData(chars: chars, inverted: false)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(_ range: ClosedRange<UnicodeScalar>, _ ranges: ClosedRange<UnicodeScalar>...) -> CharPredicateRule {
    let data = CharPredicateData(ranges: [range] + ranges, inverted: false)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(chars: [UnicodeScalar] = [], ranges: [ClosedRange<UnicodeScalar>] = [], charsIn: String = "") -> CharPredicateRule {
    let data = CharPredicateData(chars: chars, inString: charsIn, ranges: ranges, inverted: false)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(_ string: String) -> CharPredicateRule {
    let data = CharPredicateData(inString: string, inverted: false)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func charIf(_ predicate: @escaping (UnicodeScalar) -> Bool) -> CharPredicateRule {
    CharPredicateRule(predicate: predicate, data: nil)
}

extension CharacterSet {
    func toCharRule() -> CharPredicateRule {
        let data = CharPredicateData(set: self, inverted: false)
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }
}

func str(_ string: String) -> ExactStringRule {
    ExactStringRule(string: string)
}

func str(ch: UnicodeScalar, chars: UnicodeScalar...) -> StringPredicateRule {
    let data = CharPredicateData(chars: [ch] + chars, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 0...Int.max)
}

func str(_ range: ClosedRange<UnicodeScalar>, _ ranges: ClosedRange<UnicodeScalar>...) -> StringPredicateRule {
    let data = CharPredicateData(ranges: [range] + ranges, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 0...Int.max)
}

func str(chars: [UnicodeScalar] = [], ranges: [ClosedRange<UnicodeScalar>] = [], charsIn: String = "") -> StringPredicateRule {
    let data = CharPredicateData(chars: chars, inString: charsIn, ranges: ranges, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 1...Int.max)
}

func nonEmptyStr(ch: UnicodeScalar, chars: UnicodeScalar...) -> StringPredicateRule {
    let data = CharPredicateData(chars: [ch] + chars, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 1...Int.max)
}

func nonEmptyStr(_ range: ClosedRange<UnicodeScalar>, _ ranges: ClosedRange<UnicodeScalar>...) -> StringPredicateRule {
    let data = CharPredicateData(ranges: [range] + ranges, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 1...Int.max)
}

func nonEmptyStr(chars: [UnicodeScalar] = [], ranges: [ClosedRange<UnicodeScalar>] = [], charsIn: String = "") -> StringPredicateRule {
    let data = CharPredicateData(chars: chars, inString: charsIn, ranges: ranges, inverted: false)
    return StringPredicateRule(predicate: data.toPredicate(), range: 1...Int.max)
}