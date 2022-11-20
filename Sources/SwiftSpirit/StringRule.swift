//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class StringRule : RuleProtocol {
    typealias T = String

    func parse(seek: String.Index, string: Data) -> ParseState {
        ParseState(seek: seek, code: .invalidRule)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<String> {
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
    if a is AlwaysSuccessfulOneOfStringRule || b.isEmpty {
        return AlwaysSuccessfulOneOfStringRule(tree: tree)
    } else {
        return OneOfStringRule(tree: tree)
    }
}

func |(a: OneOfStringRule, b: OneOfStringRule) -> OneOfStringRule {
    let tree = TernarySearchTree(strings: a.tree.strings + b.tree.strings)
    if a is AlwaysSuccessfulOneOfStringRule || b is AlwaysSuccessfulOneOfStringRule {
        return AlwaysSuccessfulOneOfStringRule(tree: tree)
    } else {
        return OneOfStringRule(tree: tree)
    }
}

func |(a: String, b: OneOfStringRule) -> OneOfStringRule {
    let tree = TernarySearchTree(strings: [a] + b.tree.strings)
    if b is AlwaysSuccessfulOneOfStringRule || a.isEmpty {
        return AlwaysSuccessfulOneOfStringRule(tree: tree)
    } else {
        return OneOfStringRule(tree: tree)
    }
}