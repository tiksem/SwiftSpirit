//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class GrammarRule<Result> : Rule<Result> {
    private let factory: () -> Grammar<Result>
    private lazy var grammarForParse = factory()
    private var pool: [Grammar<Result>] = []
    private var seek = 0

    init(factory: @escaping () -> Grammar<Result>, name: String? = nil) {
        self.factory = factory
        #if DEBUG
        super.init(name: name ?? "grammar")
        #endif
    }

    private func takeGrammar() -> Grammar<Result> {
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

    override func parse(seek: String.Index, string: String) -> ParseState {
        grammarForParse.rule.parse(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<Result> {
        let grammar = takeGrammar()
        grammar.resetResult()
        let pRes = grammar.rule.parse(seek: seek, string: string)
        if pRes.code == .complete {
            return ParseResult(state: pRes, result: grammar.resultProvider())
        }

        return ParseResult(state: pRes, result: nil)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        grammarForParse.rule.hasMatch(seek: seek, string: string)
    }

    override func name(name: String) -> GrammarRule<Result> {
        GrammarRule(factory: factory, name: name)
    }

    override func clone() -> GrammarRule<Result> {
        GrammarRule(factory: factory, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let factory = factory
        let base = GrammarRule(factory: {
            let g = factory()
            return Grammar(rule: g.rule.debug(context: context),
                    resultProvider: g.resultProvider,
                    resetResult: g.resetResult)
        }, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    func isThreadSafe() -> Bool {
        false
    }
}

func grammar<Result>(_ factory: @escaping () -> Grammar<Result>) -> GrammarRule<Result> {
    GrammarRule(factory: factory)
}
