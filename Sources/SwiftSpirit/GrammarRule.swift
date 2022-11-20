//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class GrammarRule<Rule : RuleProtocol, Result> : RuleProtocol {
    typealias T = Result
    private let factory: () -> Grammar<Rule, Result>
    private lazy var grammarForParse = factory()
    private var pool: [Grammar<Rule, Result>] = []
    private var seek = 0

    init(factory: @escaping () -> Grammar<Rule, Result>) {
        self.factory = factory
    }

    private func takeGrammar() -> Grammar<Rule, Result> {
        if pool.count <= seek {
            pool.append(factory())
        }

        let i = seek
        seek += 1
        return pool[i]
    }

    private func returnGrammar() {
        seek -= 1
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        grammarForParse.rule.parse(seek: seek, string: string)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<Result> {
        let grammar = takeGrammar()
        grammar.resetResult()
        let pRes = grammar.rule.parse(seek: seek, string: string)
        if pRes.code == .complete {
            return ParseResult(state: pRes, result: grammar.resultProvider())
        }

        return ParseResult(state: pRes, result: nil)
    }
}

func grammar<Rule : RuleProtocol, Result>(_ factory: @escaping () -> Grammar<Rule, Result>) -> GrammarRule<Rule, Result> {
    GrammarRule(factory: factory)
}
