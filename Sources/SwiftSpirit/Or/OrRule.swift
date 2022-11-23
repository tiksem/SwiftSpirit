//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class OrRule<T> : BaseOrRule<T, T, T> {
}

func |<T> (a: BaseRule<T>, b: BaseRule<T>) -> OrRule<T> {
    OrRule<T>(a, b)
}
