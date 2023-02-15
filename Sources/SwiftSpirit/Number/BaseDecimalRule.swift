//
// Created by Semyon Tikhonenko on 12/4/22.
//

import Foundation

class BaseDecimalRule : Rule<Decimal> {
    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let r = parse(seek: seek, string: string)
        guard r.code == .complete else {
            return ParseResult(state: r, result: nil)
        }

        let str = String(string[seek..<r.seek])
        return ParseResult(state: r, result: Decimal(string: str))
    }
}
