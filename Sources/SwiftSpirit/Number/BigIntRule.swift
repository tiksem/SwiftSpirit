//
// Created by Semyon Tikhonenko on 12/4/22.
//

import Foundation

class BigIntRule : BaseDecimalRule {
    override init(name: String? = nil) {
        #if DEBUG
        super.init(name: name ?? "bigint")
        #endif
    }

    override func name(name: String) -> BigIntRule {
        BigIntRule(name: name)
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
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
            case ASCII.plus, ASCII.minus:
                if i != seek {
                    return ParseState(seek: seek, code: .invalidInt)
                }
            default:
                return ParseState(seek: i, code: successFlag ? .complete : .invalidInt)
            }

            i = s.index(after: i)
        } while i != s.endIndex

        return ParseState(seek: successFlag ? i : seek, code: successFlag ? .complete : .invalidInt)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        if seek == string.endIndex {
            return false
        }

        let s = string.utf8
        let c = s[seek]
        switch c {
        case ASCII.digits:
            return true
        case ASCII.minus, ASCII.plus:
            let nextIndex = s.index(after: seek)
            if nextIndex == string.endIndex {
                return false
            }

            return s[nextIndex].isDigit()
        default:
            return false
        }
    }
}