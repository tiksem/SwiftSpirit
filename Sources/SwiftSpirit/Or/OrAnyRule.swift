//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrAnyRule<A, B> : BaseOrRule<A, B, Any> {
}

func |<A, B> (a: BaseRule<A>, b: BaseRule<B>) -> OrAnyRule<A, B> {
    OrAnyRule<A, B>(a, b)
}