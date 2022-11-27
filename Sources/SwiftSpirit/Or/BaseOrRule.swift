//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class BaseOrRule<A, B, T> : Rule<T> {
    let a: Rule<A>
    let b: Rule<B>

    init(_ a: Rule<A>, _ b: Rule<B>, name: String? = nil) {
        self.a = a
        self.b = b
        #if DEBUG
        super.init(name: name ?? "\(a.wrappedName) or \(b.wrappedName)")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        if aRes.code == .complete {
            return aRes
        }

        return b.parse(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let aRes = a.parseWithResult(seek: seek, string: string)
        if aRes.state.code == .complete {
            return convertAResult(from: aRes)
        }

        let bRes = b.parseWithResult(seek: seek, string: string)
        return convertBResult(from: bRes)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        a.hasMatch(seek: seek, string: string) || b.hasMatch(seek: seek, string: string)
    }

    func convertAResult(from: ParseResult<A>) -> ParseResult<T> {
        from as! ParseResult<T>
    }

    func convertBResult(from: ParseResult<B>) -> ParseResult<T> {
        from as! ParseResult<T>
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = BaseOrRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }

    override var nameShouldBeWrapped: Bool {
        get { true }
    }
    #endif

    override func name(name: String) -> BaseOrRule<A, B, T> {
        BaseOrRule<A, B, T>(a, b, name: name)
    }

    override func clone() -> BaseOrRule<A, B, T> {
       BaseOrRule<A, B, T>(a.clone(), b.clone(), name: name)
    }
}

