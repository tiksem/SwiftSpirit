//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

public struct ParseResult<T> {
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

extension ParseResult : Equatable where T : Equatable {
    public static func ==(lhs: ParseResult<T>, rhs: ParseResult<T>) -> Bool {
        lhs.state == rhs.state && lhs.result == rhs.result
    }
}