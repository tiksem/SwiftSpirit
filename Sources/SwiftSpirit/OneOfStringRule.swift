//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class OneOfStringRule : StringRule {
    typealias T = String

    let tree: TernarySearchTree

    init(tree: TernarySearchTree) {
        self.tree = tree
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        guard !tree.strings.isEmpty else {
            return ParseState(seek: seek, code: .onOfStringNoMatch)
        }

        guard let endSeek = tree.parse(seek: seek, string: string.scalars) else {
            return ParseState(seek: seek, code: .onOfStringNoMatch)
        }

        return ParseState(seek: endSeek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        guard !tree.strings.isEmpty else {
            return ParseResult(seek: seek, code: .onOfStringNoMatch)
        }

        var result: String?
        guard let endSeek = tree.parseWithResult(seek: seek, string: string.scalars, out: &result) else {
            return ParseResult(seek: seek, code: .complete, result: "")
        }

        return ParseResult(seek: endSeek, code: .complete, result: result)
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        tree.hasMatch(seek: seek, string: string.scalars)
    }
}

class AlwaysSuccessfulOneOfStringRule : OneOfStringRule {
    override func parse(seek: String.Index, string: Data) -> ParseState {
        ParseState(seek: tree.parse(seek: seek, string: string.scalars) ?? seek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<String> {
        var result: String?
        let resultSeek = tree.parseWithResult(seek: seek, string: string.scalars, out: &result) ?? seek
        return ParseResult(seek: resultSeek, code: .complete, result: result ?? "")
    }

    override func hasMatch(seek: String.Index, string: Data) -> Bool {
        true
    }
}

func oneOf(firstString: String, strings: String...) -> OneOfStringRule {
    guard !strings.isEmpty else {
        if firstString.isEmpty {
            return AlwaysSuccessfulOneOfStringRule(tree: TernarySearchTree(strings: []))
        } else {
            return OneOfStringRule(tree: TernarySearchTree(strings: [firstString]))
        }
    }

    let nonEmptyStrings = strings.filter { !$0.isEmpty }
    let tree = TernarySearchTree(strings: [firstString] + nonEmptyStrings)
    if nonEmptyStrings.count == strings.count {
        return OneOfStringRule(tree: tree)
    } else {
        return AlwaysSuccessfulOneOfStringRule(tree: tree)
    }
}