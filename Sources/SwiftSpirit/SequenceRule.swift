//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class SequenceRule<A, B> : RuleProtocol where A : RuleProtocol, B : RuleProtocol {
    typealias T = Substring

    private let a: A
    private let b: B

    init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return aRes
        }

        return b.parse(seek: aRes.seek, string: string)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<Substring> {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return ParseResult(seek: aRes.seek, code: aRes.code)
        }

        let bRes = b.parse(seek: aRes.seek, string: string)
        if bRes.code == .complete {
            return ParseResult(state: bRes, result: string.original[seek..<bRes.seek])
        } else {
            return ParseResult(state: bRes, result: nil)
        }
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return false
        }

        return b.hasMatch(seek: aRes.seek, string: string)
    }
}

func +<A : RuleProtocol, B : RuleProtocol> (a: A, b: B) -> SequenceRule<A, B> {
    SequenceRule<A, B>(a, b)
}
