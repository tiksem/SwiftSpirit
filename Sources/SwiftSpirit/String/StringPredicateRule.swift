//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class StringPredicateRule : StringRule {
    let predicate: (UnicodeScalar) -> Bool
    let range: ClosedRange<Int>

    init(predicate: @escaping (UnicodeScalar) -> Bool, range: ClosedRange<Int>) {
        self.predicate = predicate
        self.range = range
    }

    override func parse(seek: Swift.String.Index, string: Data) -> ParseState {
        let scalars = string.scalars
        var i = seek.samePosition(in: scalars)!
        for _ in 0..<range.lowerBound {
            if !predicate(scalars[i]) {
                return ParseState(seek: seek, code: .predicateStringNotEnoughData)
            }
            i = scalars.index(after: i)
        }

        for _ in range.lowerBound..<range.upperBound {
            if !predicate(scalars[i]) {
                return ParseState(seek: i, code: .complete)
            }
            i = scalars.index(after: i)
        }

        return ParseState(seek: i, code: .complete)
    }

    override func parseWithResult(seek: Swift.String.Index, string: Data) -> ParseResult<T> {
        super.parseWithResult(seek: seek, string: string)
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        let scalars = string.scalars
        var i = seek.samePosition(in: scalars)!
        for _ in 0..<range.lowerBound {
            if !predicate(scalars[i]) {
                return false
            }
            i = scalars.index(after: i)
        }

        return true
    }
}

extension CharPredicateRule {
    func `repeat`(range: Range<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range.toClosed())
    }

    func `repeat`(range: ClosedRange<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range)
    }

    func `repeat`(range: PartialRangeFrom<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range.toClosed())
    }

    func `repeat`(range: PartialRangeThrough<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range.toClosed())
    }

    func `repeat`(range: PartialRangeUpTo<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range.toClosed())
    }

    func `repeat`(times: Int) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: times...times)
    }

    subscript(range: ClosedRange<Int>) -> StringPredicateRule {
        get {
            StringPredicateRule(predicate: predicate, range: range)
        }
    }

    subscript(range: Range<Int>) -> StringPredicateRule {
        get {
            StringPredicateRule(predicate: predicate, range: range.toClosed())
        }
    }

    subscript(range: PartialRangeFrom<Int>) -> StringPredicateRule {
        get {
            StringPredicateRule(predicate: predicate, range: range.toClosed())
        }
    }

    subscript(range: PartialRangeUpTo<Int>) -> StringPredicateRule {
        get {
            StringPredicateRule(predicate: predicate, range: range.toClosed())
        }
    }

    subscript(range: PartialRangeThrough<Int>) -> StringPredicateRule {
        get {
            StringPredicateRule(predicate: predicate, range: range.toClosed())
        }
    }
}

postfix operator +
postfix operator *

postfix func +(rule: CharPredicateRule) -> StringPredicateRule {
    StringPredicateRule(predicate: rule.predicate, range: 1...Int.max)
}

postfix func *(rule: CharPredicateRule) -> StringPredicateRule {
    StringPredicateRule(predicate: rule.predicate, range: 0...Int.max)
}