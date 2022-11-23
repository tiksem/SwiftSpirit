//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

class BaseRule<T> : RuleProtocol {
    func parse(seek: String.Index, string: Data) -> ParseState {
        fatalError("Not implemented")
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        fatalError("Not implemented")
    }

    func compile() -> BaseParser<T> {
        if isThreadSafe() {
            return RegularParser(originalRule: self)
        } else {
            return ThreadSafeParser(originalRule: self)
        }
    }

    func copy() -> BaseRule<T> {
        self
    }
}
