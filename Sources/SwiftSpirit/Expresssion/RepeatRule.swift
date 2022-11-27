//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class RepeatRule<T> : Rule<[T]> {
    private let repeated: Rule<T>
    private let range: ClosedRange<Int>

    init(repeated: Rule<T>, range: ClosedRange<Int>, name: String? = nil) {
        assert(range.lowerBound >= 0)
        self.range = range
        self.repeated = repeated
        #if DEBUG
        let fallbackName: String
        if range == 0...Int.max {
            fallbackName = "\(repeated.wrappedName)*"
        } else if range == 1...Int.max {
            fallbackName = "\(repeated.wrappedName)+"
        } else {
            fallbackName = "\(repeated.wrappedName).repeat(\(range.getNameToken()))"
        }

        super.init(name: name ?? fallbackName)
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        var i = seek
        for _ in 0..<range.lowerBound {
            let r = repeated.parse(seek: i, string: string)
            if r.code != .complete {
                return ParseState(seek: i, code: .repeatNotEnoughData)
            }
            i = r.seek
        }

        for _ in range {
            let r = repeated.parse(seek: i, string: string)
            if r.code != .complete || r.seek == i {
                break
            }

            i = r.seek
        }

        return ParseState(seek: i, code: .complete)
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<[T]> {
        var i = seek
        var result = [T]()
        if result.capacity < range.lowerBound {
            result.reserveCapacity(range.lowerBound)
        }

        for _ in 0..<range.lowerBound {
            let r = repeated.parseWithResult(seek: i, string: string)
            if r.state.code != .complete {
                return ParseResult(seek: i, code: .repeatNotEnoughData)
            }

            i = r.state.seek
            if let value = r.result {
                result.append(value)
            }
        }

        for _ in range {
            let r = repeated.parseWithResult(seek: i, string: string)
            if r.state.code != .complete || r.state.seek == i {
                break
            }

            i = r.state.seek
            if let value = r.result {
                result.append(value)
            }
        }

        return ParseResult(seek: i, code: .complete, result: result)
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        guard range.lowerBound > 0 else { return true }

        var i = seek
        for _ in 0..<range.lowerBound-1 {
            let r = repeated.parse(seek: i, string: string)
            if r.code != .complete {
                return false
            }
            i = r.seek
        }

        return repeated.hasMatch(seek: i, string: string)
    }

    override func clone() -> RepeatRule<T> {
        RepeatRule(repeated: repeated.clone(), range: range)
    }

    override func name(name: String) -> Rule<[T]> {
        RepeatRule(repeated: repeated, range: range, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<[T]> {
        let base = RepeatRule(repeated: repeated.debug(context: context), range: range, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func `repeat`(range: Range<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range.toClosed())
    }

    func `repeat`(range: ClosedRange<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range)
    }

    func `repeat`(range: PartialRangeUpTo<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range.toClosed())
    }

    func `repeat`(range: PartialRangeThrough<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range.toClosed())
    }

    func `repeat`(range: PartialRangeFrom<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range.toClosed())
    }

    func `repeat`(times: Int) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: times...times)
    }
}

postfix operator +
postfix operator *

postfix func +<T>(rule: Rule<T>) -> RepeatRule<T> {
    RepeatRule(repeated: rule, range: 1...Int.max)
}

postfix func *<T>(rule: Rule<T>) -> RepeatRule<T> {
    RepeatRule(repeated: rule, range: 0...Int.max)
}