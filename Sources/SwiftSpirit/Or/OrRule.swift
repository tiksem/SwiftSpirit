//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrRule<T> : BaseOrRule<T, T, T> {
    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<T> {
        let base = OrRule(a.debug(context: context), b.debug(context: context), name: name)
        return DebugRule(base: base, context: context)
    }
    #endif

    override func name(name: String) -> OrRule<T> {
        OrRule<T>(a, b, name: name)
    }

    override func clone() -> OrRule<T> {
        OrRule<T>(a.clone(), b.clone(), name: name)
    }
}

func |<T> (a: Rule<T>, b: Rule<T>) -> OrRule<T> {
    OrRule<T>(a, b)
}
