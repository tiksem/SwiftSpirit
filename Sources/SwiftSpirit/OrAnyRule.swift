//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrAnyRule<A, B> : BaseOrRule<A, B, Any> where A : RuleProtocol, B : RuleProtocol {
}

func |<A : RuleProtocol, B : RuleProtocol> (a: A, b: B) -> OrAnyRule<A, B> {
    OrAnyRule<A, B>(a, b)
}