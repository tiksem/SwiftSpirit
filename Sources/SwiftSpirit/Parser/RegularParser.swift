//
// Created by Semyon Tikhonenko on 11/22/22.
//

import Foundation

class RegularParser<T> : BaseParser<T> {
    private let originalRule: BaseRule<T>

    init(originalRule: BaseRule<T>) {
        self.originalRule = originalRule
    }

    override func getRule() -> BaseRule<T> {
        originalRule
    }
}
