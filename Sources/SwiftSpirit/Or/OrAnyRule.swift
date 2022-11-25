//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrAnyRule<A, B> : BaseOrRule<A, B, Any> {
    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = OrAnyRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    override func name(name: String) -> OrAnyRule<A, B> {
        OrAnyRule<A, B>(a, b, name: name)
    }

    override func clone() -> OrAnyRule<A, B> {
        OrAnyRule<A, B>(a.clone(), b.clone(), name: name)
    }
}

func |<A, B> (a: BaseRule<A>, b: BaseRule<B>) -> OrAnyRule<A, B> {
    OrAnyRule<A, B>(a, b)
}