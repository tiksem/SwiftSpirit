//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class UIntRule<I> : Rule<I> where I : FixedWidthInteger & UnsignedInteger {
    override init(name: String?) {
        #if DEBUG
        super.init(name: name)
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        if (seek == string.endIndex) {
            return ParseState(seek: seek, code: .eof)
        }

        var result = I(0)
        let s = string.utf8
        var i = seek.samePosition(in: s)!
        repeat {
            let ch = s[i]
            switch ch {
            case ASCII.digits:
                let digit = ch.toDigit()
                if (digit == 0 && seek == i) {
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
                    let resultBefore = result
                    result &*= 10
                    result &+= I(digit)
                    if (result < resultBefore) {
                        return ParseState(seek: seek, code: .uintOverflow)
                    }
                }
            default:
                return ParseState(seek: seek, code: seek != i ? .complete : .invalidInt)
            }

            i = s.index(after: i)
        } while i != s.endIndex

        return ParseState(seek: i, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<I> {
        if (seek == string.endIndex) {
            return ParseResult(seek: seek, code: .eof)
        }

        var result = I(0)
        let s = string.utf8
        var i = seek.samePosition(in: s)!

        repeat {
            let ch = s[i]
            switch ch {
            case ASCII.digits:
                let digit = ch.toDigit()
                if (digit == 0 && seek == i) {
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
                    let resultBefore = result
                    result &*= 10
                    result &+= I(digit)
                    if (result < resultBefore) {
                        return ParseResult(seek: i, code: .uintOverflow)
                    }
                }
            default:
                if (seek != i) {
                    return ParseResult(seek: i, code: .complete, result: result)
                } else {
                    return ParseResult(seek: i, code: .invalidInt)
                }
            }

            i = s.index(after: i)
        } while i != string.endIndex

        return ParseResult(seek: i, code: .complete, result: result)
    }

    override func name(name: String) -> UIntRule<I> {
        UIntRule(name: name)
    }
}