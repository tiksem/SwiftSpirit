//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

class QuotedRule<T, L, R> : Rule<T> {
    private let rule: Rule<T>
    private let l: Rule<L>
    private let r: Rule<R>

    init(rule: Rule<T>, l: Rule<L>, r: Rule<R>, name: String? = nil) {
        self.rule = rule
        self.l = l
        self.r = r
        #if DEBUG
        let quotedArgs = l.name == r.name ? l.name : "\(l.name),\(r.name)"
        super.init(name: name ?? "\(rule.wrappedName).quoted(\(quotedArgs))")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let lRes = l.parse(seek: seek, string: string)
        if lRes.code != .complete {
            return lRes
        }

        let ruleRes = rule.parse(seek: lRes.seek, string: string)
        if ruleRes.code != .complete {
            return ruleRes
        }

        return r.parse(seek: ruleRes.seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let lRes = l.parse(seek: seek, string: string)
        if lRes.code != .complete {
            return ParseResult(state: lRes, result: nil)
        }

        let ruleRes = rule.parseWithResult(seek: lRes.seek, string: string)
        if ruleRes.state.code != .complete {
            return ruleRes
        }

        let rRes = r.parse(seek: ruleRes.state.seek, string: string)
        if rRes.code == .complete {
            return ParseResult(state: rRes, result: ruleRes.result)
        } else {
            return ParseResult(state: rRes, result: nil)
        }
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        let lRes = l.parse(seek: seek, string: string)
        if lRes.code != .complete {
            return false
        }

        let ruleRes = rule.parse(seek: lRes.seek, string: string)
        if ruleRes.code != .complete {
            return false
        }

        return r.hasMatch(seek: ruleRes.seek, string: string)
    }

    override func clone() -> QuotedRule<T, L, R> {
        QuotedRule(rule: rule.clone(), l: l.clone(), r: r.clone(), name: name)
    }

    override func name(name: String) -> QuotedRule<T, L, R> {
        QuotedRule(rule: rule, l: l, r: r, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = QuotedRule(rule: rule.debug(context: context),
                l: l.debug(context: context), r: r.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func quoted<A, B>(_ l: Rule<A>, _ r: Rule<B>) -> QuotedRule<T, A, B> {
        QuotedRule(rule: self, l: l, r: r)
    }

    func quoted(_ l: String, _ r: String) -> QuotedRule<T, String, String> {
        quoted(str(l), str(r))
    }
}