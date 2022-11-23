//
// Created by Semyon Tikhonenko on 11/22/22.
//

import Foundation

class ThreadSafeParser<T> : BaseParser<T> {
    private let originalRule: BaseRule<T>
    private var lock = pthread_rwlock_t()
    private var rules: [pthread_t : BaseRule<T>]

    init(originalRule: BaseRule<T>) {
        self.originalRule = originalRule
        self.rules = [pthread_self() : originalRule]
        pthread_rwlock_init(&lock, nil)
    }

    override func getRule() -> BaseRule<T> {
        let thread = pthread_self()
        pthread_rwlock_rdlock(&lock)
        let rule = rules[thread]
        pthread_rwlock_unlock(&lock)
        if rule != nil {
            return rule!
        } else {
            let rule = originalRule.copy()
            pthread_rwlock_wrlock(&lock)
            rules[thread] = rule
            pthread_rwlock_unlock(&lock)
            return rule
        }
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }
}
