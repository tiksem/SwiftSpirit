//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

public struct ParseState {
    let seek: String.Index
    let code: ParseCode

    func toError() -> ParseError {
        code.toError(seek: seek)
    }
}

extension ParseState : Equatable {
    public static func ==(lhs: ParseState, rhs: ParseState) -> Bool {
        lhs.seek == rhs.seek && lhs.code == rhs.code
    }
}