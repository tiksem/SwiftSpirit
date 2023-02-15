//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

func parseFloat(seek: String.Index, string: String) -> ParseState {
    if seek == string.endIndex {
        return ParseState(seek: seek, code: .eof)
    }

    // Skip integer part
    let s = string.utf8
    var i = seek.samePosition(in: s)!
    let c = s[i]
    var noMoreDots = false
    switch c {
    case ASCII.plus, ASCII.minus, ASCII.dot:
        i = s.index(after: i)
        if i == s.endIndex {
            return ParseState(seek: seek, code: .invalidFloat)
        }

        noMoreDots = c == ASCII.dot
        if !noMoreDots && s[i] == ASCII.dot {
            i = s.index(after: i)
            if (i == s.endIndex) {
                return ParseState(seek: seek, code: .invalidFloat)
            }
            noMoreDots = true
        }

        if s[i].isDigit() {
            i = s.index(after: i)
            while i != s.endIndex && s[i].isDigit() {
                i = s.index(after: i)
            }
        } else {
            return ParseState(seek: seek, code: .invalidFloat)
        }
    case ASCII.digits:
        i = s.index(after: i)
        while i != s.endIndex && s[i].isDigit() {
            i = s.index(after: i)
        }
    default:
        return ParseState(seek: seek, code: .invalidFloat)
    }


    if (i == s.endIndex) {
        return ParseState(seek: i, code: .complete)
    }

    switch s[i] {
    case ASCII.dot:
        if noMoreDots {
            if i == seek {
                return ParseState(seek: seek, code: .invalidFloat)
            } else {
                return ParseState(seek: i, code: .complete)
            }
        }

        i = s.index(after: i)
        while i != s.endIndex && s[i].isDigit() {
            i = s.index(after: i)
        }

        let saveI = i
        if i != s.endIndex {
            let v = s[i]
            i = s.index(after: i)
            switch v {
            case ASCII.e, ASCII.E:
                if i != s.endIndex {
                    let c2 = s[i]
                    switch c2 {
                    case ASCII.plus, ASCII.minus:
                        i = s.index(after: i)
                        if (i != s.endIndex && s[i].isDigit()) {
                            i = s.index(after: i)
                            while i != s.endIndex && s[i].isDigit() {
                                i = s.index(after: i)
                            }

                            return ParseState(seek: i, code: .complete)
                        } else {
                            return ParseState(seek: s.index(i, offsetBy: -2), code: .complete)
                        }
                    default:
                        if s[i].isDigit() {
                            i = s.index(after: i)
                            while i != s.endIndex && s[i].isDigit() {
                                i = s.index(after: i)
                            }

                            return ParseState(seek: i, code: .complete)
                        } else {
                            return ParseState(seek: s.index(before: i), code: .complete)
                        }
                    }
                } else {
                    return ParseState(seek: saveI, code: .complete)
                }
            default:
                i = s.index(before: i)
                return ParseState(seek: i, code: .complete)
            }
        } else {
            return ParseState(seek: saveI, code: .complete)
        }
    case ASCII.E, ASCII.e:
        let saveI = i
        i = s.index(after: i)

        if i != s.endIndex {
            if s[i] == ASCII.minus {
                i = s.index(after: i)
                if (i != s.endIndex && s[i].isDigit()) {
                    i = s.index(after: i)
                    while i != s.endIndex && s[i].isDigit() {
                        i = s.index(after: i)
                    }

                    return ParseState(seek: i, code: .complete)
                } else {
                    return ParseState(seek: s.index(i, offsetBy: -2), code: .complete)
                }
            } else {
                if (s[i].isDigit()) {
                    i = s.index(after: i)
                    while i != s.endIndex && s[i].isDigit() {
                        i = s.index(after: i)
                    }

                    return ParseState(seek: i, code: .complete)
                } else {
                    return ParseState(seek: s.index(before: i), code: .complete)
                }
            }
        } else {
            return ParseState(seek: saveI, code: .complete)
        }
    default:
        return ParseState(seek: i, code: .complete)
    }
}

func hasFloatMatch(seek: String.Index, string: String) -> Bool {
    if (seek == string.endIndex) {
        return false
    }

    let s = string.utf8
    let i = seek.samePosition(in: s)!
    var c = s[i]

    if c.isDigit() {
        return true
    }
    if c == ASCII.dot {
        let next = s.index(after: i)
        return next != s.endIndex && s[next].isDigit()
    }

    if c == ASCII.plus || c == ASCII.minus {
        let next = s.index(after: i)
        if next != s.endIndex {
            c = s[next]
            if c.isDigit() {
                return true
            } else if c == ASCII.dot {
                let afterNext = s.index(after: next)
                return afterNext != s.endIndex && s[afterNext].isDigit()
            } else {
                return false
            }
        } else {
            return false
        }
    }

    return false
}

class FloatRule<T : BinaryFloatingPoint> : Rule<T> {
    override init(name: String?) {
        #if DEBUG
        super.init(name: name)
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        parseFloat(seek: seek, string: string)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        if seek == string.endIndex {
            return ParseResult(seek: seek, code: .eof)
        }

        // Skip integer part
        let s = string.utf8
        var i = seek.samePosition(in: s)!
        var c = s[i]
        var noMoreDots = false
        var integerPart = T(0.0)
        var fractionPart = T(0.0)
        let minus = c == ASCII.minus

        if minus || c == ASCII.plus || c == ASCII.dot {
            i = s.index(after: i)

            if (i == string.endIndex) {
                return ParseResult(seek: seek, code: .invalidFloat)
            }

            noMoreDots = c == ASCII.dot

            if (!noMoreDots && s[i] == ASCII.dot) {
                i = s.index(after: i)
                if (i == s.endIndex) {
                    return ParseResult(seek: seek, code: .invalidFloat)
                }
                noMoreDots = true
            }

            c = s[i]
            if noMoreDots {
                var e = T(10.0)
                if c.isDigit() {
                    fractionPart = T(c.toDigit()) / e
                    i = s.index(after: i)
                    while i != s.endIndex {
                        c = s[i]
                        if (c.isDigit()) {
                            e *= 10
                            fractionPart += T(c.toDigit()) / e
                            i = s.index(after: i)
                        } else {
                            break
                        }
                    }
                } else {
                    return ParseResult(seek: seek, code: .invalidFloat)
                }
            } else {
                if c.isDigit() {
                    integerPart = T(c.toDigit())
                    i = s.index(after: i)
                    while i != s.endIndex {
                        c = s[i]
                        if c.isDigit() {
                            integerPart *= 10
                            integerPart += T(c.toDigit())
                            i = s.index(after: i)
                        } else {
                            break
                        }
                    }
                } else {
                    return ParseResult(seek: seek, code: .invalidFloat)
                }
            }
        } else if c.isDigit()  {
            integerPart = T(c.toDigit())
            i = s.index(after: i)
            while i != s.endIndex {
                c = s[i]
                if c.isDigit() {
                    integerPart *= 10
                    integerPart += T(c.toDigit())
                    i = s.index(after: i)
                } else {
                    break
                }
            }
        } else {
            return ParseResult(seek: seek, code: .invalidFloat)
        }

        if i == s.endIndex {
            return ParseResult(seek: i, code: .complete,
                    result: minus ? -integerPart - fractionPart : integerPart + fractionPart)
        }

        let saveI = i
        switch s[i] {
        case ASCII.dot:
            i = s.index(after: i)
            if noMoreDots || i == s.endIndex {
                return ParseResult(seek: i, code: .complete,
                        result: minus ? -integerPart - fractionPart : integerPart + fractionPart)
            }

            c = s[i]
            var e = T(10.0)
            if c.isDigit() {
                fractionPart = T(c.toDigit()) / e
                i = s.index(after: i)
                while (i != s.endIndex) {
                    c = s[i]
                    if c.isDigit() {
                        e *= 10
                        fractionPart += T(c.toDigit()) / e
                        i = s.index(after: i)
                    } else {
                        break
                    }
                }
            } else if c != ASCII.e && c != ASCII.E {
                return ParseResult(seek: saveI, code: .complete,
                        result: minus ? -integerPart : integerPart)
            }

            if (i != s.endIndex) {
                i = s.index(after: i)
                let v = s[i]
                if v == ASCII.e || v == ASCII.E {
                    var exp = 0
                    if i != s.endIndex {
                        c = s[i]
                        if c == ASCII.minus || c == ASCII.plus {
                            i = s.index(after: i)
                            let expMinus = c == ASCII.minus
                            if i != s.endIndex {
                                c = s[i]
                                if c.isDigit() {
                                    i = s.index(after: i)
                                    exp = c.toDigit()
                                    while i != s.endIndex {
                                        c = s[i]
                                        if c.isDigit() {
                                            i = s.index(after: i)
                                            exp *= 10
                                            exp += c.toDigit()
                                        } else {
                                            break
                                        }
                                    }

                                    var data = minus ? -integerPart - fractionPart : integerPart + fractionPart

                                    if (expMinus) {
                                        data /= T(getPowerOf10(exp: exp))
                                    } else {
                                        data *= T(getPowerOf10(exp: exp))
                                    }
                                    return ParseResult(seek: i, code: .complete, result: data)
                                } else {
                                    return ParseResult(
                                        seek: s.index(i, offsetBy: -2),
                                        code: .complete,
                                        result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                                    )
                                }
                            } else {
                                return ParseResult(
                                    seek: s.index(i, offsetBy: -2),
                                    code: .complete,
                                    result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                                )
                            }
                        } else {
                            c = s[i]
                            if c.isDigit() {
                                i = s.index(after: i)
                                exp = c.toDigit()
                                while i != s.endIndex {
                                    c = s[i]
                                    if c.isDigit() {
                                        i = s.index(after: i)
                                        exp *= 10
                                        exp += c.toDigit()
                                    } else {
                                        break
                                    }
                                }
                                let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                                return ParseResult(
                                    seek: s.index(i, offsetBy: -2),
                                    code: .complete,
                                    result: r * T(getPowerOf10(exp: exp))
                                )
                            } else {
                                return ParseResult(
                                    seek: s.index(before: i),
                                    code: .complete,
                                    result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                                )
                            }
                        }
                    } else {
                        return ParseResult(
                            seek: saveI,
                            code: .complete,
                            result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                        )
                    }
                } else {
                    return ParseResult(
                        seek: s.index(before: i),
                        code: .complete,
                        result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                    )
                }
            } else {
                return ParseResult(
                    seek: i,
                    code: .complete,
                    result: minus ? -integerPart - fractionPart : integerPart + fractionPart
                )
            }
        case ASCII.e, ASCII.E:
            var exp = 0
            i = s.index(after: i)
            if i != s.endIndex {
                c = s[i]
                if c == ASCII.plus || c == ASCII.minus {
                    i = s.index(after: i)
                    let expMinus = c == ASCII.minus
                    if i != s.endIndex {
                        c = s[i]
                        if c.isDigit() {
                            i = s.index(after: i)
                            exp = c.toDigit()
                            while i != s.endIndex {
                                c = s[i]
                                if c.isDigit() {
                                    i = s.index(after: i)
                                    exp *= 10
                                    exp += c.toDigit()
                                } else {
                                    break
                                }
                            }

                            var r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                            if (expMinus) {
                                r /= T(getPowerOf10(exp: exp))
                            } else {
                                r *= T(getPowerOf10(exp: exp))
                            }

                            return ParseResult(seek: i, code: .complete, result: r)
                        } else {
                            let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                            return ParseResult(seek: s.index(i, offsetBy: -2), code: .complete, result: r)
                        }
                    } else {
                        let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                        return ParseResult(seek: s.index(i, offsetBy: -2), code: .complete, result: r)
                    }
                } else {
                    c = s[i]
                    if c.isDigit() {
                        i = s.index(after: i)
                        exp = c.toDigit()
                        while i != s.endIndex {
                            c = s[i]
                            if c.isDigit() {
                                i = s.index(after: i)
                                exp *= 10
                                exp += c.toDigit()
                            } else {
                                break
                            }
                        }
                        let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                        return ParseResult(seek: i, code: .complete, result: r * T(getPowerOf10(exp: exp)))
                    } else {
                        let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                        return ParseResult(seek: s.index(before: i), code: .complete, result: r)
                    }
                }
            } else {
                let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
                return ParseResult(seek: saveI, code: .complete, result: r)
            }
        default:
            let r = minus ? -integerPart - fractionPart : integerPart + fractionPart
            return ParseResult(seek: i, code: .complete, result: r)
        }
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        hasFloatMatch(seek: seek, string: string)
    }

    override func name(name: String) -> FloatRule<T> {
        FloatRule(name: name)
    }
}
