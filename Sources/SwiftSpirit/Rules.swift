//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

let int = IntRule<Int>()
let int8 = IntRule<Int8>()
let int16 = IntRule<Int16>()
let int32 = IntRule<Int32>()
let int64 = IntRule<Int64>()

let float = FloatRule<Float>()
let double = FloatRule<Double>()

let char = AnyCharRule()

func char(_ ch: UnicodeScalar) -> CharPredicateRule {
    let data = CharPredicateData(singleChar: ch)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(_ chars: UnicodeScalar...) -> CharPredicateRule {
    let data = CharPredicateData(chars: chars)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(_ ranges: ClosedRange<UnicodeScalar>...) -> CharPredicateRule {
    let data = CharPredicateData(ranges: ranges)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func char(chars: [UnicodeScalar], ranges: [ClosedRange<UnicodeScalar>]) -> CharPredicateRule {
    let data = CharPredicateData(chars: chars, ranges: ranges)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}