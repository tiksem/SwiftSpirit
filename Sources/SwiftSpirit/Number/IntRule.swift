//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class IntRule<I> : BaseRule<I> where I : FixedWidthInteger & SignedInteger {
    override init(name: String?) {
        #if DEBUG
        super.init(name: name)
        #endif
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        if (seek == string.endIndex) {
            return ParseState(seek: seek, code: .eof)
        }

        var result = I(0)
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
                    result &*= 10
                    result &+= I(digit)
                    if (result < 0) {
                        return ParseState(seek: seek, code: .intOverflow)
                    }
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

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<I> {
        if (seek == string.endIndex) {
            return ParseResult(seek: seek, code: .eof)
        }

        var result = I(0)
        var successFlag = false
        let s = string.utf8
        var i = seek.samePosition(in: s)!
        var sign = 1
        repeat {
            let ch = s[i]
            switch ch {
            case ASCII.digits:
                let digit = ch.toDigit()
                if (digit == 0 && !successFlag) {
                    let nextIndex = s.index(after: i)
                    if (nextIndex == s.endIndex) {
                        return ParseResult(seek: nextIndex, code: .complete, result: 0)
                    } else {
                        let nextChar = s[nextIndex]
                        if (nextChar.isDigit()) {
                            return ParseResult(seek: i, code: .numberStartedFromZero)
                        } else {
                            return ParseResult(seek: nextIndex, code: .complete, result: 0)
                        }
                    }
                } else {
                    successFlag = true
                    result &*= 10
                    result &+= I(digit)
                    if (result < 0) {
                        return ParseResult(seek: i, code: .intOverflow)
                    }
                }
            case ASCII.minus:
                sign = -1
                if i != seek {
                    return ParseResult(seek: seek, code: .invalidInt)
                }
            case ASCII.plus:
                if i != seek {
                    return ParseResult(seek: seek, code: .invalidInt)
                }
            default:
                if (successFlag) {
                    return ParseResult(seek: i, code: .complete, result: result * I(sign))
                } else {
                    return ParseResult(seek: i, code: .invalidInt)
                }
            }

            i = s.index(after: i)
        } while i != string.endIndex

        return ParseResult(seek: i, code: .complete, result: result * I(sign))
    }

    override func name(name: String) -> IntRule<I> {
        IntRule(name: name)
    }
}