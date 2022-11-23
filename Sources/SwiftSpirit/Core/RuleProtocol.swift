//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

protocol RuleProtocol : AnyObject {
    associatedtype T

    func parse(seek: String.Index, string: Data) -> ParseState
    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T>
    func hasMatch(seek: String.Index, string: Data) -> Bool

    func isThreadSafe() -> Bool
}

extension RuleProtocol {
    func hasMatch(seek: String.Index, string: Data) -> Bool {
        parse(seek: seek, string: string).code == .complete
    }

    func isThreadSafe() -> Bool {
        true
    }
}
