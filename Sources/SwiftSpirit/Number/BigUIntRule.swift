//
// Created by Semyon Tikhonenko on 12/4/22.
//

import Foundation

class BigUIntRule : BaseDecimalRule {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "biguint")
        #endif
    }

    override func name(name: String) -> BigUIntRule {
        BigUIntRule(name: name)
    }

    override func parse(seek: Swift.String.Index, string: String) -> ParseState {
        if (seek == string.endIndex) {
            return ParseState(seek: seek, code: .eof)
        }

        var successFlag = false
        let s = string.utf8
        var i = seek.samePosition(in: s)!
        repeat {
            let ch = s[i]
            switch ch {
            case ASCII.digits:
                let digit = ch.toDigit()
                if (digit == 0 && !successFlag) {
                    let nextIndex = s.index(after: i)
                    if (nextIndex == s.endIndex) {
                        return ParseState(seek: nextIndex, code: .complete)
                    } else {
                        let nextChar = s[nextIndex]
                        if (nextChar.isDigit()) {
                            return ParseState(seek: seek, code: .numberStartedFromZero)
                        } else {
                            return ParseState(seek: nextIndex, code: .complete)
                        }
                    }
                } else {
                    successFlag = true
                }
            default:
                return ParseState(seek: i, code: successFlag ? .complete : .invalidInt)
            }

            i = s.index(after: i)
        } while i != s.endIndex

        return ParseState(seek: i, code: .complete)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        if seek == string.endIndex {
            return false
        }

        let s = string.utf8
        let c = s[seek]

        return c.isDigit()
    }
}
