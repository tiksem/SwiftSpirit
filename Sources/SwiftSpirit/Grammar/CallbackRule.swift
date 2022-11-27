//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class CallbackRule<T> : Rule<T> {

    private let rule: Rule<T>
    private let callback: (T) -> Void

    init(rule: Rule<T>, callback: @escaping (T) -> Void, name: String? = nil) {
        self.rule = rule
        self.callback = callback
        #if DEBUG
        super.init(name: name ?? "callback")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        parseWithResult(seek: seek, string: string).state
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let res = rule.parseWithResult(seek: seek, string: string)
        if res.state.code == .complete {
            callback(res.result!)
        }

        return res
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        rule.hasMatch(seek: seek, string: string)
    }

    override func clone() -> CallbackRule<T> {
        CallbackRule(rule: rule.clone(), callback: callback, name: name)
    }

    override func name(name: String) -> CallbackRule<T> {
        CallbackRule(rule: rule, callback: callback, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = CallbackRule(rule: rule.debug(context: context), callback: callback, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func get(_ callback: @escaping (T) -> Void) -> CallbackRule<T> {
        CallbackRule<T>(rule: self, callback: callback)
    }
}