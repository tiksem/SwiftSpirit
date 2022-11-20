//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

struct Grammar<Rule : RuleProtocol, Result> {
    let rule: Rule
    let resultProvider: () -> Result
    let resetResult: () -> ()

    init(rule: Rule, resultProvider: @escaping () -> Result, resetResult: @escaping () -> ()) {
        self.rule = rule
        self.resultProvider = resultProvider
        self.resetResult = resetResult
    }
}