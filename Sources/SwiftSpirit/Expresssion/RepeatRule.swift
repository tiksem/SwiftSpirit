//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class RepeatRule<T> : BaseRule<[T]> {
    private let repeated: BaseRule<T>
    private let range: ClosedRange<Int>

    init(repeated: BaseRule<T>, range: ClosedRange<Int>) {
        assert(range.lowerBound >= 0)
        self.range = range
        self.repeated = repeated
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
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

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<[T]> {
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

    func hasMatch(seek: String.Index, string: Data) -> Bool {
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
}

extension BaseRule {
    func `repeat`(range: Range<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range.lowerBound...range.upperBound - 1)
    }

    func `repeat`(range: ClosedRange<Int>) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: range)
    }

    func `repeat`(times: Int) -> RepeatRule<T> {
        RepeatRule(repeated: self, range: times...times)
    }
}

postfix operator +
postfix operator *

postfix func +<T>(rule: BaseRule<T>) -> RepeatRule<T> {
    RepeatRule(repeated: rule, range: 1...Int.max)
}

postfix func *<T>(rule: BaseRule<T>) -> RepeatRule<T> {
    RepeatRule(repeated: rule, range: 0...Int.max)
}