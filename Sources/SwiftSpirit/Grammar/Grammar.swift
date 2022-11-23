//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

struct Grammar<Result> {
    let rule: BaseRule<Any>
    let resultProvider: () -> Result
    let resetResult: () -> ()

    init(rule: BaseRule<Any>, resultProvider: @escaping () -> Result, resetResult: @escaping () -> ()) {
        self.rule = rule
        self.resultProvider = resultProvider
        self.resetResult = resetResult
    }
}