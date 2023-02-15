//
// Created by Semyon Tikhonenko on 2/15/23.
//

import Foundation

class ResultCallbackRule<T> : Rule<T> {
    private let base: Rule<T>
    private let callback: (T) -> Void

    init(base: Rule<T>, callback: @escaping (T) -> Void, name: String? = nil) {
        self.base = base
        self.callback = callback
        #if DEBUG
        super.init(name: name ?? "resultCallback")
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

        if let result = res.result {
            callback(result)
        }

        return res
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        base.hasMatch(seek: seek, string: string)
    }

    override func clone() -> ResultCallbackRule<T> {
        ResultCallbackRule<T>(base: base.clone(), callback: callback, name: name)
    }

    override func name(name: String) -> ResultCallbackRule<T> {
        ResultCallbackRule(base: base, callback: callback, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = ResultCallbackRule(base: base.debug(context: context), callback: callback, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func on(_ callback: @escaping (T) -> Void) -> ResultCallbackRule<T> {
        ResultCallbackRule(base: self, callback: callback)
    }
}