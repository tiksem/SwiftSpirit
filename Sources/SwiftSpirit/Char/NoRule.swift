//
// Created by Semyon Tikhonenko on 11/25/22.
//

import Foundation

class NoRule<T> : BaseRule<UnicodeScalar> {
    private let rule: BaseRule<T>

    init(rule: BaseRule<T>, name: String? = nil) {
        self.rule = rule
        #if DEBUG
        super.init(name: name)
        #endif
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        if rule.hasMatch(seek: seek, string: string) {
            return ParseState(seek: seek, code: .noFailed)
        }

        let resultSeek: String.Index
        if seek == string.endIndex {
            resultSeek = seek
        } else {
            resultSeek = string.scalars.index(after: seek)
        }

        return ParseState(seek: resultSeek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<UnicodeScalar> {
        if rule.hasMatch(seek: seek, string: string) {
            return ParseResult(seek: seek, code: .noFailed)
        }

        if seek == string.endIndex {
            return ParseResult(seek: seek, code: .complete, result: UnicodeScalar(0))
        }

        return ParseResult(seek: string.scalars.index(after: seek), code: .complete, result: string.scalars[seek])
    }

    func hasMatch(seek: Swift.String.Index, string: Data) -> Bool {
        !rule.hasMatch(seek: seek, string: string)
    }

    override func name(name: String) -> NoRule<T> {
        NoRule(rule: rule, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<UnicodeScalar> {
        let base = NoRule<T>(rule: rule.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

prefix func !<T>(a: BaseRule<T>) -> NoRule<T> {
    NoRule(rule: a)
}
