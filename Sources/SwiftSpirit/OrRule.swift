//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrRule<A, B> : BaseOrRule<A, B, A.T> where A : RuleProtocol, B : RuleProtocol, A.T == B.T {
}

func |<A : RuleProtocol, B : RuleProtocol> (a: A, b: B) -> OrRule<A, B> where A.T == B.T {
    OrRule<A, B>(a, b)
}
