//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class CallbackRule<Rule : RuleProtocol> : RuleProtocol {
    typealias T = Rule.T

    private let rule: Rule
    private let callback: (T) -> Void

    init(rule: Rule, callback: @escaping (T) -> Void) {
        self.rule = rule
        self.callback = callback
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        parseWithResult(seek: seek, string: string).state
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        let res = rule.parseWithResult(seek: seek, string: string)
        if res.state.code == .complete {
            callback(res.result!)
        }

        return res
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        rule.hasMatch(seek: seek, string: string)
    }
}

extension RuleProtocol {
    func get(_ callback: @escaping (T) -> Void) -> CallbackRule<Self> {
        CallbackRule(rule: self, callback: callback)
    }
}