//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

public class ExpectationRule<A, B> : Rule<A> {
    private let rule: Rule<A>
    private let expectationRule: Rule<B>

    init(rule: Rule<A>, expectationRule: Rule<B>, name: String? = nil) {
        self.rule = rule
        self.expectationRule = expectationRule
        #if DEBUG
        super.init(name: name ?? "\(rule.wrappedName) expects \(expectationRule.wrappedName)")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let res = rule.parse(seek: seek, string: string)
        if res.code != .complete {
            return res
        }

        if expectationRule.hasMatch(seek: res.seek, string: string) {
            return res
        }

        return ParseState(seek: seek, code: .expectationFailed)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let res = rule.parseWithResult(seek: seek, string: string)
        if res.state.code != .complete {
            return res
        }

        if expectationRule.hasMatch(seek: res.state.seek, string: string) {
            return res
        }

        return ParseResult(seek: seek, code: .expectationFailed)
    }

    override func name(name: String) -> ExpectationRule<A, B> {
        ExpectationRule(rule: rule, expectationRule: expectationRule, name: name)
    }

    override func clone() -> ExpectationRule<A, B> {
        ExpectationRule(rule: rule.clone(), expectationRule: expectationRule.clone(), name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = ExpectationRule(rule: rule.debug(context: context),
                expectationRule: expectationRule.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }

    override var nameShouldBeWrapped: Bool {
        get { true }
    }
    #endif
}

extension Rule {
    func expects<E>(_ expectation: Rule<E>) -> ExpectationRule<T, E> {
        ExpectationRule(rule: self, expectationRule: expectation)
    }
}
