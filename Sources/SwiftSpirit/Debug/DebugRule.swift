//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

#if DEBUG
class DebugRule<T> : Rule<T> {
    private let base: Rule<T>
    private let context: DebugContext

    init(base: Rule<T>, context: DebugContext) {
        self.base = base
        self.context = context
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        context.parseStarted(name: base.name, seek: seek)
        return base.parse(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        context.parseStarted(name: base.name, seek: seek)
        return base.parseWithResult(seek: seek, string: string)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        base.hasMatch(seek: seek, string: string)
    }

    func isThreadSafe() -> Bool {
        false
    }
}
#endif