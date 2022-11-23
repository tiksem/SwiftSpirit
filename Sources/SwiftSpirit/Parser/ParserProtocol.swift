//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

protocol ParserProtocol : AnyObject {
    associatedtype T

    func matches(string: String) -> Bool
    func parse(string: String) -> ParseState
    func parseWithResult(string: String) -> ParseResult<T>
    func tryParse(string: String) -> String.Index?
}
