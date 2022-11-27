//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

class AnyCharacterRule : Rule<Character> {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "character")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        guard seek.samePosition(in: string) != nil else {
            return ParseState(seek: seek, code: .invalidUnicodeScalarsSeek)
        }

        return ParseState(seek: string.index(after: seek), code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        guard seek.samePosition(in: string) != nil else {
            return ParseResult(seek: seek, code: .invalidUnicodeScalarsSeek)
        }

        return ParseResult(seek: string.index(after: seek), code: .complete, result: string[seek])
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        guard seek != string.endIndex else { return false }
        return seek.samePosition(in: string) != nil
    }

    override func name(name: String) -> AnyCharacterRule {
        AnyCharacterRule(name: name)
    }
}
