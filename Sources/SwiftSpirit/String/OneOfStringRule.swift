//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class OneOfStringRule : StringRule {
    typealias T = String

    let tree: TernarySearchTree
    let errorParseCode: ParseCode

    init(tree: TernarySearchTree, errorParseCode: ParseCode = .oneOfStringNoMatch) {
        self.tree = tree
        self.errorParseCode = errorParseCode
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        guard !tree.strings.isEmpty else {
            return ParseState(seek: seek, code: errorParseCode)
        }

        guard let endSeek = tree.parse(seek: seek, string: string.scalars) else {
            return ParseState(seek: seek, code: errorParseCode)
        }

        return ParseState(seek: endSeek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        guard !tree.strings.isEmpty else {
            return ParseResult(seek: seek, code: errorParseCode)
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

func oneOf(firstString: String, strings: String...) -> OneOfStringRule {
    guard !strings.isEmpty else {
        let errorCode: ParseCode = firstString.isEmpty ? .complete : .oneOfStringNoMatch
        return OneOfStringRule(tree: TernarySearchTree(strings: [firstString]), errorParseCode: errorCode)
    }

    let nonEmptyStrings = strings.filter { !$0.isEmpty }
    let tree = TernarySearchTree(strings: [firstString] + nonEmptyStrings)
    let errorCode: ParseCode = nonEmptyStrings.count == strings.count ? .complete : .oneOfStringNoMatch
    return OneOfStringRule(tree: tree, errorParseCode: errorCode)
}