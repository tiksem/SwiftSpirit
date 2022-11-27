//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class BaseParser<T> : ParserProtocol {
    func getRule(string: String) -> Rule<T> {
        fatalError("Override getRule")
    }

    func matches(string: String) -> Bool {
        string.matches(rule: getRule(string: string))
    }

    func parse(string: String) -> ParseState {
        string.parse(rule: getRule(string: string))
    }

    func parseWithResult(string: String) -> ParseResult<T> {
        string.parseWithResult(rule: getRule(string: string))
    }

    func parseValueOrThrow(string: String) throws -> T {
        try string.parseValueOrThrow(rule: getRule(string: string))
    }

    func tryParse(string: String) -> Swift.String.Index? {
        string.tryParse(rule: getRule(string: string))
    }

    func tryParseValue(string: String) -> T? {
        string.tryParseValue(rule: getRule(string: string))
    }

    func matchesAtBeginning(string: String) -> Bool {
        string.startsWith(rule: getRule(string: string))
    }

    func findFirstMatch(in string: String) -> Range<String.Index>? {
        string.findFirstMatch(rule: getRule(string: string))
    }

    func findFirstValue(in string: String) -> T? {
        string.findFirstValue(rule: getRule(string: string))
    }

    func findAllMatches(in string: String) -> [Range<String.Index>] {
        string.findAllMatches(rule: getRule(string: string))
    }

    func findAllValues(in string: String) -> [T] {
        string.findAllValues(rule: getRule(string: string))
    }

    func findAll(in string: String, callback: (Range<String.Index>, T?) -> ()) {
        string.findAll(rule: getRule(string: string), callback: callback)
    }

    func replaceFirst(in string: String, with replacement: String) -> String {
        string.replaceFirst(rule: getRule(string: string), with: replacement)
    }

    func replaceFirst(in string: String, replacementProvider: (T) -> String) -> String {
        string.replaceFirst(rule: getRule(string: string), replacementProvider: replacementProvider)
    }

    func replaceFirst<Replacement: CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String {
        string.replaceFirst(rule: getRule(string: string), replacementProvider: replacementProvider)
    }

    func replaceAll(in string: String, with replacement: String) -> String {
        string.replaceAll(rule: getRule(string: string), with: replacement)
    }

    func replaceAll<Replacement: CustomStringConvertible>(in string: String, replacementProvider: (T) -> Replacement) -> String {
        string.replaceAll(rule: getRule(string: string), replacementProvider: replacementProvider)
    }
}