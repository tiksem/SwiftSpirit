//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class OneOfStringRule : StringRule {
    typealias T = String

    let tree: TernarySearchTree
    let errorParseCode: ParseCode

    init(tree: TernarySearchTree, errorParseCode: ParseCode = .oneOfStringNoMatch, name: String? = nil) {
        self.tree = tree
        self.errorParseCode = errorParseCode
        #if DEBUG
        super.init(name: name ?? "oneOf(\(tree.strings.map { $0.replacingOccurrences(of: "|", with: "`|`") }.joined(separator: "|")))")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        guard !tree.strings.isEmpty else {
            return ParseState(seek: seek, code: errorParseCode)
        }

        guard let endSeek = tree.parse(seek: seek, string: string.unicodeScalars) else {
            return ParseState(seek: seek, code: errorParseCode)
        }

        return ParseState(seek: endSeek, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        guard !tree.strings.isEmpty else {
            return ParseResult(seek: seek, code: errorParseCode)
        }

        var result: String?
        guard let endSeek = tree.parseWithResult(seek: seek, string: string.unicodeScalars, out: &result) else {
            return ParseResult(seek: seek, code: .complete, result: "")
        }

        return ParseResult(seek: endSeek, code: .complete, result: result)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        tree.hasMatch(seek: seek, string: string.unicodeScalars)
    }

    override func name(name: String) -> OneOfStringRule {
        OneOfStringRule(tree: tree, errorParseCode: errorParseCode, name: name)
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