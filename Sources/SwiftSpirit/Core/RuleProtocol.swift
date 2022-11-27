//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

protocol RuleProtocol : AnyObject {
    associatedtype T

    func parse(seek: String.Index, string: String) -> ParseState
    func parseWithResult(seek: String.Index, string: String) -> ParseResult<T>
    func hasMatch(seek: String.Index, string: String) -> Bool

    func isThreadSafe() -> Bool
}

extension RuleProtocol {
    func hasMatch(seek: String.Index, string: String) -> Bool {
        parse(seek: seek, string: string).code == .complete
    }

    func isThreadSafe() -> Bool {
        true
    }
}
