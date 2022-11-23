//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class SequenceRule<A, B> : BaseRule<Substring> {
    private let a: BaseRule<A>
    private let b: BaseRule<B>

    init(_ a: BaseRule<A>, _ b: BaseRule<B>) {
        self.a = a
        self.b = b
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return aRes
        }

        return b.parse(seek: aRes.seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<Substring> {
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

func +<A, B>(a: BaseRule<A>, b: BaseRule<B>) -> SequenceRule<A, B> {
    SequenceRule<A, B>(a, b)
}