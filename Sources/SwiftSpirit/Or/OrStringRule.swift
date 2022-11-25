//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class OrAStringBSubstringRule : BaseOrRule<String, Substring, String> {
    override func convertAResult(from: ParseResult<String>) -> ParseResult<String> {
        from
    }

    override func convertBResult(from: ParseResult<Substring>) -> ParseResult<String> {
        ParseResult(state: from.state, result: String(from.result!))
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = OrAStringBSubstringRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    override func name(name: String) -> OrAStringBSubstringRule {
        OrAStringBSubstringRule(a, b, name: name)
    }

    override func clone() -> OrAStringBSubstringRule {
        OrAStringBSubstringRule(a.clone(), b.clone(), name: name)
    }
}

class OrASubstringBStringRule : BaseOrRule<Substring, String, String> {

    override func convertAResult(from: ParseResult<Substring>) -> ParseResult<String> {
        ParseResult(state: from.state, result: String(from.result!))
    }

    override func convertBResult(from: ParseResult<String>) -> ParseResult<String> {
        from
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = OrASubstringBStringRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    override func name(name: String) -> OrASubstringBStringRule {
        OrASubstringBStringRule(a, b, name: name)
    }

    override func clone() -> OrASubstringBStringRule {
        OrASubstringBStringRule(a.clone(), b.clone(), name: name)
    }
}

func |(a: BaseRule<String>, b: BaseRule<Substring>) -> OrAStringBSubstringRule {
    OrAStringBSubstringRule(a, b)
}

func |(a: BaseRule<Substring>, b: BaseRule<String>) -> OrASubstringBStringRule {
    OrASubstringBStringRule(a, b)
}