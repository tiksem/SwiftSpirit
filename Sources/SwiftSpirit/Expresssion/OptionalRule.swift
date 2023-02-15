//
// Created by Semyon Tikhonenko on 11/27/22.
//

import Foundation

class OptionalRule<T> : Rule<T> {
    private let rule: Rule<T>

    init(rule: Rule<T>, name: String? = nil) {
        self.rule = rule
        #if DEBUG
        super.init(name: name)
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let res = rule.parse(seek: seek, string: string)
        if res.code == .complete {
            return res
        } else {
            return ParseState(seek: res.seek, code: .complete)
        }
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let res = rule.parseWithResult(seek: seek, string: string)
        if res.state.code == .complete {
            return res
        } else {
            return ParseResult(seek: res.state.seek, code: .complete)
        }
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        true
    }
}
