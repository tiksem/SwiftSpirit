//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

class AnyCharRule : RuleProtocol {
    typealias T = UnicodeScalar

    func parse(seek: String.Index, string: Data) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        return ParseState(seek: string.scalars.index(after: seek), code: .complete)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        return ParseResult(seek: string.scalars.index(after: seek), code: .complete, result: string.scalars[seek])
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        seek != string.endIndex
    }
}

func -(a: AnyCharRule, b: CharPredicateRule) -> CharPredicateRule {
    CharPredicateRule(predicate: {
        !b.predicate($0)
    })
}

func -(a: CharPredicateRule, b: AnyCharRule) -> CharPredicateRule {
    CharPredicateRule(predicate: { _ in false }, data: CharPredicateData(set: CharacterSet()))
}

func -(a: AnyCharRule, b: CharacterSet) -> CharPredicateRule {
    CharPredicateRule(predicate: {
        !b.contains($0)
    })
}

func -(a: CharacterSet, b: AnyCharRule) -> CharPredicateRule {
    CharPredicateRule(predicate: { _ in false }, data: CharPredicateData(set: CharacterSet()))
}