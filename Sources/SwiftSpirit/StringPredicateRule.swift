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
}

extension CharPredicateRule {
    func `repeat`(range: Range<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range.lowerBound...range.upperBound - 1)
    }

    func `repeat`(range: ClosedRange<Int>) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: range)
    }

    func `repeat`(times: Int) -> StringPredicateRule {
        StringPredicateRule(predicate: predicate, range: times...times)
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