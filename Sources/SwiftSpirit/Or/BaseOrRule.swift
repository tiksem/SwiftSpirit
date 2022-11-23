//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class BaseOrRule<A, B, T> : BaseRule<T> {
    private let a: BaseRule<A>
    private let b: BaseRule<B>

    init(_ a: BaseRule<A>, _ b: BaseRule<B>) {
        self.a = a
        self.b = b
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        if aRes.code == .complete {
            return aRes
        }

        return b.parse(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
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

    func convertAResult(from: ParseResult<A>) -> ParseResult<T> {
        from as! ParseResult<T>
    }

    func convertBResult(from: ParseResult<B>) -> ParseResult<T> {
        from as! ParseResult<T>
    }

    override func copy() -> BaseOrRule<A, B, T> {
       BaseOrRule<A, B, T>(a.copy(), b.copy())
    }
}

