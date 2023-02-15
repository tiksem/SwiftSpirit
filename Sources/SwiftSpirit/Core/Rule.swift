//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

public class Rule<T> : RuleProtocol {
    #if DEBUG
    let name: String
    #else
    var name: String? { get { nil } }
    #endif

    init(name: String? = nil) {
        #if DEBUG
        self.name = name ?? "error"
        #endif
    }

    #if DEBUG
    dynamic func parse(seek: String.Index, string: String) -> ParseState {
        fatalError("Not implemented")
    }

    dynamic func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        fatalError("Not implemented")
    }
    #else
    func parse(seek: String.Index, string: String) -> ParseState {
        fatalError("Not implemented")
    }

    func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        fatalError("Not implemented")
    }
    #endif

    func compile() -> BaseParser<T> {
        #if DEBUG
            return DebugParser(originalRule: self)
        #else
        if isThreadSafe() {
            return RegularParser(originalRule: self)
        } else {
            return ThreadSafeParser(originalRule: self)
        }
        #endif
    }

    func clone() -> Rule<T> {
        self
    }

    func name(name: String) -> Rule<T> {
        self
    }

    #if DEBUG
    func debug(context: DebugContext) -> DebugRule<T> {
        DebugRule(base: self, context: context)
    }

    var nameShouldBeWrapped: Bool {
        get { false }
    }

    var wrappedName: String {
        get { "(\(name))" }
    }
    #endif
}

extension Rule {
    @inline(__always) func findFirstSuccessfulRange(in string: String) -> Range<String.Index>? {
        var seek = string.startIndex
        repeat {
            let result = parse(seek: seek, string: string)
            if result.code == .complete {
                return seek..<result.seek
            }

            let newSeek = result.seek
            if (newSeek == seek) {
                seek = string.index(after: seek)
            } else {
                seek = newSeek
            }
        } while (seek != string.endIndex)

        return nil
    }

    struct SearchResult {
        let range: Range<String.Index>
        let value: T?
    }

    @inline(__always) func findFirstSuccessfulResult(in string: String) -> SearchResult? {
        var seek = string.startIndex
        repeat {
            let result = parseWithResult(seek: seek, string: string)
            if result.state.code == .complete {
                return SearchResult(range: seek..<result.state.seek, value: result.result)
            }

            let newSeek = result.state.seek
            if (newSeek == seek) {
                seek = string.index(after: seek)
            } else {
                seek = newSeek
            }
        } while (seek != string.endIndex)

        return nil
    }

    @inline(__always) func findAllSuccessfulRanges(in string: String) -> [Range<String.Index>] {
        var seek = string.startIndex
        var list = [Range<String.Index>]()
        repeat {
            let result = parse(seek: seek, string: string)
            if result.code == .complete {
                list.append(seek..<result.seek)
            }

            let newSeek = result.seek
            if (newSeek == seek) {
                seek = string.index(after: seek)
            } else {
                seek = newSeek
            }
        } while (seek != string.endIndex)

        return list
    }

    @inline(__always) func countOccurrences(in string: String) -> Int {
        var seek = string.startIndex
        var count = 0
        repeat {
            let result = parse(seek: seek, string: string)
            if result.code == .complete {
                count+=1
            }

            let newSeek = result.seek
            if (newSeek == seek) {
                seek = string.index(after: seek)
            } else {
                seek = newSeek
            }
        } while (seek != string.endIndex)

        return count
    }

    @inline(__always) func findAllSuccessfulResults(
            in string: String, callback: (_ range: Range<String.Index>, _ value: T?) -> Void
    ) {
        var seek = string.startIndex
        repeat {
            let result = parseWithResult(seek: seek, string: string)
            if result.state.code == .complete {
                callback(seek..<result.state.seek, result.result)
            }

            let newSeek = result.state.seek
            if (newSeek == seek) {
                seek = string.index(after: seek)
            } else {
                seek = newSeek
            }
        } while (seek != string.endIndex)
    }
}
