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
    func tryParseValue(string: String) -> T?
    func parseValueOrThrow(string: String) throws -> T
    func matchesAtBeginning(string: String) -> Bool

    func findFirstMatch(in string: String) -> Range<String.Index>?
    func findFirstValue(in string: String) -> T?
    func findAllMatches(in string: String) -> [Range<String.Index>]
    func findAllValues(in string: String) -> [T]
    func findAll(in string: String, callback: (_ range: Range<String.Index>, _ value: T?) -> Void)

    func replaceFirst(in string: String, with replacement: String) -> String
    func replaceFirst(in string: String, replacementProvider: (T) -> String) -> String
    func replaceFirst<Replacement : CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String
    func replaceAll(in string: String, with replacement: String) -> String
    func replaceAll<Replacement : CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String
}
