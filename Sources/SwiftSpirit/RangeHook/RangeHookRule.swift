//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

class RangeHookRule<T> : Rule<T> {
    private let base: Rule<T>
    private let hook: RangeHookProtocol & AnyObject

    init(base: Rule<T>, hook: RangeHookProtocol & AnyObject, name: String? = nil) {
        self.base = base
        self.hook = hook
        #if DEBUG
        super.init(name: name ?? "rangeHook")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let res = base.parse(seek: seek, string: string)
        if res.code != .complete {
            return res
        }

        hook.submit(range: seek..<res.seek)

        return res
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let res = base.parseWithResult(seek: seek, string: string)
        if res.state.code != .complete {
            return res
        }

        hook.submit(range: seek..<res.state.seek)

        return res
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        base.hasMatch(seek: seek, string: string)
    }

    override func clone() -> RangeHookRule<T> {
        RangeHookRule(base: base.clone(), hook: hook, name: name)
    }

    override func name(name: String) -> RangeHookRule<T> {
        RangeHookRule(base: base, hook: hook, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = RangeHookRule<T>(base: base.debug(context: context), hook: hook, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func rangeHook(_ hook: RangeHookProtocol) -> RangeHookRule<T> {
        RangeHookRule(base: self, hook: hook)
    }
}