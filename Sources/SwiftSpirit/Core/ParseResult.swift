//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

struct ParseResult<T> {
    let state: ParseState
    let result: T?

    init(seek: String.Index, code: ParseCode, result: T? = nil) {
        state = ParseState(seek: seek, code: code)
        self.result = result
    }

    init(state: ParseState, result: T?) {
        self.state = state
        self.result = result
    }
}