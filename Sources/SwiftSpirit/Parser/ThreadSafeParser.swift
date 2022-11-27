//
// Created by Semyon Tikhonenko on 11/22/22.
//

import Foundation

class ThreadSafeParser<T> : BaseParser<T> {
    private let originalRule: Rule<T>
    //TODO: Reimplement with lock-free data structure
    private var lock = pthread_rwlock_t()
    private var rules: NSMapTable<Thread, Rule<T>> = NSMapTable.weakToStrongObjects()

    init(originalRule: Rule<T>) {
        self.originalRule = originalRule
        rules.setObject(originalRule, forKey: Thread.current)
        pthread_rwlock_init(&lock, nil)
    }

    override func getRule(string: String) -> Rule<T> {
        let thread = Thread.current
        pthread_rwlock_rdlock(&lock)
        let rule = rules.object(forKey: thread)
        pthread_rwlock_unlock(&lock)
        if rule != nil {
            return rule!
        } else {
            let rule = originalRule.clone()
            pthread_rwlock_wrlock(&lock)
            rules.setObject(rule, forKey: thread)
            pthread_rwlock_unlock(&lock)
            return rule
        }
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }
}
