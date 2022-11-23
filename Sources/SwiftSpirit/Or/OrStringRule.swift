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
}

class OrASubstringBStringRule : BaseOrRule<Substring, String, String> {

    override func convertAResult(from: ParseResult<Substring>) -> ParseResult<String> {
        ParseResult(state: from.state, result: String(from.result!))
    }

    override func convertBResult(from: ParseResult<String>) -> ParseResult<String> {
        from
    }
}

func |(a: BaseRule<String>, b: BaseRule<Substring>) -> OrAStringBSubstringRule {
    OrAStringBSubstringRule(a, b)
}

func |(a: BaseRule<Substring>, b: BaseRule<String>) -> OrASubstringBStringRule {
    OrASubstringBStringRule(a, b)
}