//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

class AnyCharRule : BaseRule<UnicodeScalar> {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "char")
        #endif
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        return ParseState(seek: string.scalars.index(after: seek), code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        return ParseResult(seek: string.scalars.index(after: seek), code: .complete, result: string.scalars[seek])
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        seek != string.endIndex
    }

    override func name(name: String) -> AnyCharRule {
        AnyCharRule(name: name)
    }
}

func -(a: CharPredicateRule, b: AnyCharRule) -> CharPredicateRule {
    CharPredicateRule(predicate: { _ in false }, data: CharPredicateData(set: CharacterSet(), inverted: false))
}