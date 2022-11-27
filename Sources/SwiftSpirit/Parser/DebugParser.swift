//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

#if DEBUG
class DebugParser<T> : ThreadSafeParser<T> {
    override func getRule(string: String) -> Rule<T> {
        let context = DebugContext(string: string)
        return DebugRule(base: super.getRule(string: string), context: context)
    }
}
#endif
