//
// Created by Semyon Tikhonenko on 11/25/22.
//

import Foundation

class NoRule<T> : Rule<UnicodeScalar> {
    private let rule: Rule<T>

    init(rule: Rule<T>, name: String? = nil) {
        self.rule = rule
        #if DEBUG
        super.init(name: name ?? "!\(rule.wrappedName)")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        if rule.hasMatch(seek: seek, string: string) {
            return ParseState(seek: seek, code: .noFailed)
        }

        let resultSeek: String.Index
        if seek == string.endIndex {
            resultSeek = seek
        } else {
            resultSeek = string.unicodeScalars.index(after: seek)
        }

        return ParseState(seek: resultSeek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<UnicodeScalar> {
        if rule.hasMatch(seek: seek, string: string) {
            return ParseResult(seek: seek, code: .noFailed)
        }

        if seek == string.endIndex {
            return ParseResult(seek: seek, code: .complete, result: UnicodeScalar(0))
        }

        return ParseResult(seek: string.unicodeScalars.index(after: seek), code: .complete, result: string.unicodeScalars[seek])
    }

    func hasMatch(seek: Swift.String.Index, string: String) -> Bool {
        !rule.hasMatch(seek: seek, string: string)
    }

    override func name(name: String) -> NoRule<T> {
        NoRule(rule: rule, name: name)
    }

    override func clone() -> NoRule<T> {
        NoRule(rule: rule.clone())
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<UnicodeScalar> {
        let base = NoRule<T>(rule: rule.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

prefix func !<T>(a: Rule<T>) -> NoRule<T> {
    NoRule(rule: a)
}
