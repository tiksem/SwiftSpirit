//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class CallbackRule<T> : BaseRule<T> {

    private let rule: BaseRule<T>
    private let callback: (T) -> Void

    init(rule: BaseRule<T>, callback: @escaping (T) -> Void) {
        self.rule = rule
        self.callback = callback
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        parseWithResult(seek: seek, string: string).state
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
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

extension BaseRule {
    func get(_ callback: @escaping (T) -> Void) -> CallbackRule<T> {
        CallbackRule<T>(rule: self, callback: callback)
    }
}