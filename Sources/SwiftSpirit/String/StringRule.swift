//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class StringRule : Rule<String> {
    override func parse(seek: String.Index, string: String) -> ParseState {
        ParseState(seek: seek, code: .invalidRule)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<String> {
        ParseResult(seek: seek, code: .invalidRule)
    }
}

func |(a: String, b: String) -> OneOfStringRule {
    oneOf(firstString: a, strings: b)
}

func |(a: OneOfStringRule, b: ExactStringRule) -> OneOfStringRule {
    a | b.string
}

func |(a: ExactStringRule, b: OneOfStringRule) -> OneOfStringRule {
    a.string | b
}

func |(a: ExactStringRule, b: ExactStringRule) -> OneOfStringRule {
    a.string | b.string
}

func |(a: OneOfStringRule, b: String) -> OneOfStringRule {
    let tree = TernarySearchTree(strings: a.tree.strings + [b])
    let errorCode: ParseCode = a.errorParseCode == .complete || b.isEmpty ? .complete : .oneOfStringNoMatch
    return OneOfStringRule(tree: tree, errorParseCode: errorCode)
}

func |(a: OneOfStringRule, b: OneOfStringRule) -> OneOfStringRule {
    let tree = TernarySearchTree(strings: a.tree.strings + b.tree.strings)
    let errorCode: ParseCode = a.errorParseCode == .complete || b.errorParseCode == .complete ?
            .complete : .oneOfStringNoMatch
    return OneOfStringRule(tree: tree, errorParseCode: errorCode)
}

func |(a: String, b: OneOfStringRule) -> OneOfStringRule {
    let tree = TernarySearchTree(strings: [a] + b.tree.strings)
    let errorCode: ParseCode = b.errorParseCode == .complete || a.isEmpty ? .complete : .oneOfStringNoMatch
    return OneOfStringRule(tree: tree, errorParseCode: errorCode)
}