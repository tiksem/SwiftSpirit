//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class BaseParser<T> : ParserProtocol {
    func getRule() -> BaseRule<T> {
        fatalError("Override getRule")
    }

    func matches(string: String) -> Bool {
        let res = getRule().parse(seek: string.startIndex, string: Data(string: string))
        return res.code == .complete && res.seek == string.endIndex
    }

    func parse(string: String) -> ParseState {
        getRule().parse(seek: string.startIndex, string: Data(string: string))
    }

    func parseWithResult(string: String) -> ParseResult<T> {
        getRule().parseWithResult(seek: string.startIndex, string: Data(string: string))
    }

    func tryParse(string: String) -> Swift.String.Index? {
        let res = getRule().parse(seek: string.startIndex, string: Data(string: string))
        if (res.code == .complete) {
            return res.seek
        }

        return nil
    }
}