//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

class QuotedRule<T, L, R> : BaseRule<T> {
    private let rule: BaseRule<T>
    private let l: BaseRule<L>
    private let r: BaseRule<R>

    init(rule: BaseRule<T>, l: BaseRule<L>, r: BaseRule<R>, name: String? = nil) {
        self.rule = rule
        self.l = l
        self.r = r
        #if DEBUG
        let quotedArgs = l.name == r.name ? l.name : "\(l.name), \(r.name)"
        super.init(name: name ?? "\(rule.wrappedName).quoted(\(quotedArgs))")
        #endif
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
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

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
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

    func hasMatch(seek: String.Index, string: Data) -> Bool {
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

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = QuotedRule(rule: rule.debug(context: context),
                l: l.debug(context: context), r: r.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension BaseRule {
    func quoted<A, B>(_ l: BaseRule<A>, _ r: BaseRule<B>) -> QuotedRule<T, A, B> {
        QuotedRule(rule: self, l: l, r: r)
    }

    func quoted(_ l: String, _ r: String) -> QuotedRule<T, String, String> {
        quoted(str(l), str(r))
    }
}