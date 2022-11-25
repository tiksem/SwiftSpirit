//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class BaseParser<T> : ParserProtocol {
    func getRule() -> BaseRule<T> {
        fatalError("Override getRule")
    }

    func matches(string: String) -> Bool {
        string.matches(rule: getRule())
    }

    func parse(string: String) -> ParseState {
        string.parse(rule: getRule())
    }

    func parseWithResult(string: String) -> ParseResult<T> {
        string.parseWithResult(rule: getRule())
    }

    func parseValueOrThrow(string: String) throws -> T {
        try string.parseValueOrThrow(rule: getRule())
    }

    func tryParse(string: String) -> Swift.String.Index? {
        string.tryParse(rule: getRule())
    }

    func matchesAtBeginning(string: String) -> Bool {
        string.startsWith(rule: getRule())
    }

    func findFirstMatch(in string: String) -> Range<String.Index>? {
        string.findFirstMatch(rule: getRule())
    }

    func findFirstValue(in string: String) -> T? {
        string.findFirstValue(rule: getRule())
    }

    func findAllMatches(in string: String) -> [Range<String.Index>] {
        string.findAllMatches(rule: getRule())
    }

    func findAllValues(in string: String) -> [T] {
        string.findAllValues(rule: getRule())
    }

    func findAll(in string: String, callback: (Range<String.Index>, T?) -> ()) {
        string.findAll(rule: getRule(), callback: callback)
    }

    func replaceFirst(in string: String, with replacement: String) -> String {
        string.replaceFirst(rule: getRule(), with: replacement)
    }

    func replaceFirst(in string: String, replacementProvider: (T) -> String) -> String {
        string.replaceFirst(rule: getRule(), replacementProvider: replacementProvider)
    }

    func replaceFirst<Replacement: CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String {
        string.replaceFirst(rule: getRule(), replacementProvider: replacementProvider)
    }

    func replaceAll(in string: String, with replacement: String) -> String {
        string.replaceAll(rule: getRule(), with: replacement)
    }

    func replaceAll<Replacement: CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String {
        string.replaceAll(rule: getRule(), replacementProvider: replacementProvider)
    }
}