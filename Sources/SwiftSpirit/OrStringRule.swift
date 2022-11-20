//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class OrAStringBSubstringRule<A : RuleProtocol, B : RuleProtocol> : BaseOrRule<A, B, String>
        where A.T == String, B.T == Substring {

    override func convertAResult(from: ParseResult<String>) -> ParseResult<String> {
        from
    }

    override func convertBResult(from: ParseResult<Substring>) -> ParseResult<String> {
        ParseResult(state: from.state, result: String(from.result!))
    }
}

class OrASubstringBStringRule<A : RuleProtocol, B : RuleProtocol> : BaseOrRule<A, B, String>
        where A.T == Substring, B.T == String {

    override func convertAResult(from: ParseResult<Substring>) -> ParseResult<String> {
        ParseResult(state: from.state, result: String(from.result!))
    }

    override func convertBResult(from: ParseResult<String>) -> ParseResult<String> {
        from
    }
}

func |<A : RuleProtocol, B : RuleProtocol>(a: A, b: B) -> OrAStringBSubstringRule<A, B> where A.T == String, B.T == Substring {
    OrAStringBSubstringRule(a, b)
}

func |<A : RuleProtocol, B : RuleProtocol>(a: A, b: B) -> OrASubstringBStringRule<A, B> where A.T == Substring, B.T == String {
    OrASubstringBStringRule(a, b)
}