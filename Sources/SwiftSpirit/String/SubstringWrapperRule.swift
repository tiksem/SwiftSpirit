//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

class SubstringWrapperRule<T> : Rule<Substring> {
    private let wrapped: Rule<T>

    init(wrapped: Rule<T>, name: String? = nil) {
        self.wrapped = wrapped
        #if DEBUG
        super.init(name: name ?? "\(wrapped.wrappedName).asString")
        #endif
    }

    override func parse(seek: Swift.String.Index, string: String) -> ParseState {
        wrapped.parse(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<Substring> {
        let res = wrapped.parse(seek: seek, string: string)
        return ParseResult(state: res, result: string[seek..<res.seek])
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        wrapped.hasMatch(seek: seek, string: string)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<Substring> {
        let base = SubstringWrapperRule(wrapped: wrapped.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    override func name(name: String) -> SubstringWrapperRule<T> {
        SubstringWrapperRule(wrapped: wrapped, name: name)
    }
}

extension Rule {
    func asString() -> SubstringWrapperRule<T> {
        SubstringWrapperRule(wrapped: self)
    }
}
