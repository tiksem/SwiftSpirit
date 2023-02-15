//
// Created by Semyon Tikhonenko on 12/4/22.
//

import Foundation

class DecimalRule : Rule<Decimal> {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "decimal")
        #endif
    }

    override func name(name: String) -> DecimalRule {
        DecimalRule(name: name)
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        parseFloat(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let r = parseFloat(seek: seek, string: string)
        guard r.code == .complete else {
            return ParseResult(state: r, result: nil)
        }

        let str = String(string[seek..<r.seek])
        if let result = Decimal(string: str) {
            return ParseResult(state: r, result: result)
        } else {
            return ParseResult(seek: seek, code: .decimalOverflow)
        }
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        hasFloatMatch(seek: seek, string: string)
    }
}