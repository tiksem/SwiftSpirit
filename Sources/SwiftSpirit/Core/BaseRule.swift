//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

public class BaseRule<T> : RuleProtocol {
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
    dynamic func parse(seek: String.Index, string: Data) -> ParseState {
        fatalError("Not implemented")
    }

    dynamic func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        fatalError("Not implemented")
    }
    #else
    func parse(seek: String.Index, string: Data) -> ParseState {
        fatalError("Not implemented")
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        fatalError("Not implemented")
    }
    #endif

    func compile() -> BaseParser<T> {
        if isThreadSafe() {
            return RegularParser(originalRule: self)
        } else {
            return ThreadSafeParser(originalRule: self)
        }
    }

    func clone() -> BaseRule<T> {
        self
    }

    func name(name: String) -> BaseRule<T> {
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

extension BaseRule {
    @inline(__always) func findFirstSuccessfulRange(string: String) -> Range<String.Index>? {
        let data = Data(string: string)
        var seek = string.startIndex
        repeat {
            let result = parse(seek: seek, string: data)
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

    @inline(__always) func findFirstSuccessfulResult(string: String) -> SearchResult? {
        let data = Data(string: string)
        var seek = string.startIndex
        repeat {
            let result = parseWithResult(seek: seek, string: data)
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

    @inline(__always) func findAllSuccessfulRanges(string: String) -> [Range<String.Index>] {
        let data = Data(string: string)
        var seek = string.startIndex
        var list = [Range<String.Index>]()
        repeat {
            let result = parse(seek: seek, string: data)
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

    @inline(__always) func findAllSuccessfulResults(
            string: String, callback: (_ range: Range<String.Index>, _ value: T?) -> Void
    ) {
        let data = Data(string: string)
        var seek = string.startIndex
        repeat {
            let result = parseWithResult(seek: seek, string: data)
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
