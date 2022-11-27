//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class SequenceRule<A, B> : Rule<Substring> {
    private let a: Rule<A>
    private let b: Rule<B>

    init(_ a: Rule<A>, _ b: Rule<B>, name: String? = nil) {
        self.a = a
        self.b = b
        #if DEBUG
        super.init(name: name ?? "\(a.wrappedName)+\(b.wrappedName)")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return aRes
        }

        return b.parse(seek: aRes.seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<Substring> {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return ParseResult(seek: aRes.seek, code: aRes.code)
        }

        let bRes = b.parse(seek: aRes.seek, string: string)
        if bRes.code == .complete {
            return ParseResult(state: bRes, result: string[seek..<bRes.seek])
        } else {
            return ParseResult(state: bRes, result: nil)
        }
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        let aRes = a.parse(seek: seek, string: string)
        guard aRes.code == .complete else {
            return false
        }

        return b.hasMatch(seek: aRes.seek, string: string)
    }

    override func clone() -> SequenceRule<A, B> {
        SequenceRule(a.clone(), b.clone(), name: name)
    }

    override func name(name: String) -> SequenceRule {
        SequenceRule(a, b, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = SequenceRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }

    override var nameShouldBeWrapped: Bool {
        get { true }
    }
    #endif
}

func +<A, B>(a: Rule<A>, b: Rule<B>) -> SequenceRule<A, B> {
    SequenceRule<A, B>(a, b)
}
