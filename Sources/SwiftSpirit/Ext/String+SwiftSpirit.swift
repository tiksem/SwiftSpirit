//
// Created by Semyon Tikhonenko on 11/25/22.
//

import Foundation

public extension String {
    func matches<T>(rule: Rule<T>) -> Bool {
        let res = rule.parse(seek: startIndex, string: self)
        return res.code == .complete && res.seek == endIndex
    }

    func parse<T>(rule: Rule<T>) -> ParseState {
        rule.parse(seek: startIndex, string: self)
    }

    func parseOrThrow<T>(rule: Rule<T>) throws -> String.Index {
        let result = rule.parse(seek: startIndex, string: self)
        if result.code == .complete {
            return result.seek
        }

        throw result.toError()
    }

    func parseWithResult<T>(rule: Rule<T>) -> ParseResult<T> {
        rule.parseWithResult(seek: startIndex, string: self)
    }

    func parseValueOrThrow<T>(rule: Rule<T>) throws -> T {
        assert(!(rule is OptionalRule), file: "parseValueOrThrow is not supported for root optional rule")
        let r = parseWithResult(rule: rule)
        if r.state.code != .complete {
            throw r.state.code.toError(seek: r.state.seek)
        }

        return r.result!
    }

    func tryParse<T>(rule: Rule<T>) -> Swift.String.Index? {
        let res = rule.parse(seek: startIndex, string: self)
        if (res.code == .complete) {
            return res.seek
        }

        return nil
    }

    func tryParseValue<T>(rule: Rule<T>) -> T? {
        rule.parseWithResult(seek: startIndex, string: self).result
    }

    func startsWith<T>(rule: Rule<T>) -> Bool {
        rule.hasMatch(seek: startIndex, string: self)
    }

    func indexOf<T>(rule: Rule<T>) -> String.Index? {
        rule.findFirstSuccessfulRange(string: self)?.lowerBound
    }

    func findFirstMatch<T>(rule: Rule<T>) -> Range<String.Index>? {
        rule.findFirstSuccessfulRange(string: self)
    }

    func findFirstValue<T>(rule: Rule<T>) -> T? {
        rule.findFirstSuccessfulResult(string: self)?.value
    }

    func findAllMatches<T>(rule: Rule<T>) -> [Range<String.Index>] {
        rule.findAllSuccessfulRanges(string: self)
    }

    func findAllValues<T>(rule: Rule<T>) -> [T] {
        var result = [T]()
        rule.findAllSuccessfulResults(string: self) { range, value in
            if let v = value {
                result.append(v)
            }
        }

        return result
    }

    func findAll<T>(rule: Rule<T>, callback: (_ range: Range<String.Index>, _ value: T?) -> Void) {
        rule.findAllSuccessfulResults(string: self, callback: callback)
    }

    func replaceFirst<T>(rule: Rule<T>, with replacement: String) -> String {
        if let range = rule.findFirstSuccessfulRange(string: self) {
            return self.replacingCharacters(in: range, with: replacement)
        }

        return self
    }

    func replaceFirst<T>(rule: Rule<T>, replacementProvider: (T) -> String) -> String {
        if let result = rule.findFirstSuccessfulResult(string: self),
           let value: T = result.value
        {
            return self.replacingCharacters(in: result.range, with: replacementProvider(value))
        }

        return self
    }

    func replaceFirst<T, Replacement : CustomStringConvertible>(rule: Rule<T>, replacementProvider: (T) -> Replacement) -> String {
        if let result = rule.findFirstSuccessfulResult(string: self),
           let value: T = result.value
        {
            return self.replacingCharacters(in: result.range, with: replacementProvider(value).description)
        }

        return self
    }

    func replaceAll<T>(rule: Rule<T>, with replacement: String) -> String {
        var result = ""
        let ranges = rule.findAllSuccessfulRanges(string: self)
        if ranges.isEmpty {
            return self
        }

        var index = startIndex
        for range in ranges {
            result += self[index..<range.lowerBound]
            index = range.upperBound
            result += replacement
        }

        result += self[index..<endIndex]

        return result
    }

    func replaceAll<T, Replacement : CustomStringConvertible>(rule: Rule<T>, replacementProvider: (T) -> Replacement) -> String {
        var result = ""
        var index = startIndex
        rule.findAllSuccessfulResults(string: self) { range, value in
            if let v = value {
                result += self[index..<range.lowerBound]
                index = range.upperBound
                result += replacementProvider(v).description
            }
        }

        if (index == startIndex) {
            return self
        }

        result += self[index..<endIndex]

        return result
    }
}