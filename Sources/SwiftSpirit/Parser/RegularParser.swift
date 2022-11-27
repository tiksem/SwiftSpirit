//
// Created by Semyon Tikhonenko on 11/22/22.
//

import Foundation

class RegularParser<T> : BaseParser<T> {
    private let originalRule: Rule<T>

    init(originalRule: Rule<T>) {
        self.originalRule = originalRule
    }

    override func getRule(string: String) -> Rule<T> {
        originalRule
    }
}
