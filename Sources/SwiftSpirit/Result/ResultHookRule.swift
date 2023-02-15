//
// Created by Semyon Tikhonenko on 2/15/23.
//

import Foundation

class ResultHookRule<Hook : ResultHookProtocol> : Rule<Hook.T> {
    private let base: Rule<Hook.T>
    private let hook: Hook

    init(base: Rule<Hook.T>, hook: Hook, name: String? = nil) {
        self.base = base
        self.hook = hook
        #if DEBUG
        super.init(name: name ?? "resultHook")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        parseWithResult(seek: seek, string: string).state
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let res = base.parseWithResult(seek: seek, string: string)
        if res.state.code != .complete {
            return res
        }

        hook.submit(value: res.result)

        return res
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        base.hasMatch(seek: seek, string: string)
    }

    override func clone() -> ResultHookRule<Hook> {
        ResultHookRule<Hook>(base: base.clone(), hook: hook, name: name)
    }

    override func name(name: String) -> ResultHookRule<Hook> {
        ResultHookRule(base: base, hook: hook, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<Hook.T> {
        let base = ResultHookRule<Hook>(base: base.debug(context: context), hook: hook, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func resultHook<Hook : ResultHookProtocol>(_ hook: Hook) -> ResultHookRule<Hook> where Hook.T == T {
        ResultHookRule(base: self, hook: hook)
    }
}