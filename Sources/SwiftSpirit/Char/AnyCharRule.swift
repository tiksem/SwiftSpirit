//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

class AnyCharRule : Rule<UnicodeScalar> {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "char")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        return ParseState(seek: string.unicodeScalars.index(after: seek), code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        return ParseResult(
                seek: string.unicodeScalars.index(after: seek), code: .complete,
                result: string.unicodeScalars[seek])
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        seek != string.endIndex
    }

    override func name(name: String) -> AnyCharRule {
        AnyCharRule(name: name)
    }
}

func -(a: CharPredicateRule, b: AnyCharRule) -> CharPredicateRule {
    CharPredicateRule(predicate: { _ in false }, data: CharPredicateData(set: CharacterSet(), inverted: false))
}