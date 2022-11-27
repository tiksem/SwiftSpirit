//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class ExactStringRule : StringRule {
    typealias T = String

    let string: String

    init(string: String, name: String? = nil) {
        self.string = string
        #if DEBUG
        super.init(name: name ??
                "str(\(string.replacingOccurrences(of: "(", with: "`(`").replacingOccurrences(of: ")", with: "`)`"))")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        guard seek.samePosition(in: string) != nil else {
            return ParseState(seek: seek, code: .exactStringNoMatch)
        }

        guard let endIndex = string.index(seek, offsetBy: self.string.count, limitedBy: string.endIndex) else {
            return ParseState(seek: seek, code: .exactStringNoMatch)
        }

        guard string[seek..<endIndex] == self.string else {
            return ParseState(seek: seek, code: .exactStringNoMatch)
        }

        return ParseState(seek: endIndex, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        guard seek.samePosition(in: string) != nil else {
            return ParseResult(seek: seek, code: .exactStringNoMatch)
        }

        guard let endIndex = string.index(seek, offsetBy: self.string.count, limitedBy: string.endIndex) else {
            return ParseResult(seek: seek, code: .exactStringNoMatch)
        }

        guard string[seek..<endIndex] == self.string else {
            return ParseResult(seek: seek, code: .exactStringNoMatch)
        }

        return ParseResult(seek: endIndex, code: .complete, result: self.string)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        string[seek...].starts(with: self.string)
    }

    override func name(name: String) -> ExactStringRule {
        ExactStringRule(string: string, name: name)
    }
}
