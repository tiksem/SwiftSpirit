//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class BaseOrRule<A, B, T> : RuleProtocol where A : RuleProtocol, B : RuleProtocol {
    private let a: A
    private let b: B

    init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        if aRes.code == .complete {
            return aRes
        }

        return b.parse(seek: seek, string: string)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        let aRes = a.parseWithResult(seek: seek, string: string)
        if aRes.state.code == .complete {
            return convertAResult(from: aRes)
        }

        let bRes = b.parseWithResult(seek: seek, string: string)
        return convertBResult(from: bRes)
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        a.hasMatch(seek: seek, string: string) || b.hasMatch(seek: seek, string: string)
    }

    func convertAResult(from: ParseResult<A.T>) -> ParseResult<T> {
        from as! ParseResult<T>
    }

    func convertBResult(from: ParseResult<B.T>) -> ParseResult<T> {
        from as! ParseResult<T>
    }
}

