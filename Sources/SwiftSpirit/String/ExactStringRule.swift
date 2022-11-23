//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class ExactStringRule : StringRule {
    typealias T = String

    let string: String

    init(string: String) {
        self.string = string
    }

    override func parse(seek: Swift.String.Index, string: Data) -> ParseState {
        let s = string.original
        guard let endIndex = s.index(seek, offsetBy: self.string.count, limitedBy: s.endIndex) else {
            return ParseState(seek: seek, code: .exactStringNoMatch)
        }

        guard s[seek..<endIndex] == self.string else {
            return ParseState(seek: seek, code: .exactStringNoMatch)
        }

        return ParseState(seek: endIndex, code: .complete)
    }

    override func parseWithResult(seek: Swift.String.Index, string: Data) -> ParseResult<T> {
        let s = string.original
        guard let endIndex = s.index(seek, offsetBy: self.string.count, limitedBy: s.endIndex) else {
            return ParseResult(seek: seek, code: .exactStringNoMatch)
        }

        guard s[seek..<endIndex] == self.string else {
            return ParseResult(seek: seek, code: .exactStringNoMatch)
        }

        return ParseResult(seek: endIndex, code: .complete, result: self.string)
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        string.original[seek...].starts(with: self.string)
    }
}
