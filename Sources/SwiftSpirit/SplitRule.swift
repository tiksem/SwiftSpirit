//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

class SplitRule<Main : RuleProtocol, Divider : RuleProtocol> : RuleProtocol {
    typealias T = [Main.T]

    let main: Main
    let divider: Divider
    let range: ClosedRange<Int>

    init(main: Main, divider: Divider, range: ClosedRange<Int>) {
        self.main = main
        self.divider = divider
        self.range = range
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        var i = seek

        if (range.lowerBound != 0) {
            for _ in 0..<range.lowerBound {
                let mainRes = main.parse(seek: i, string: string)
                if (mainRes.code != .complete) {
                    return ParseState(seek: i, code: .splitNotEnoughData)
                }
                i = mainRes.seek

                let dividerRes = divider.parse(seek: i, string: string)
                if (dividerRes.code != .complete) {
                    return ParseState(seek: i, code: .splitNotEnoughData)
                }
                i = dividerRes.seek
            }

            let mainRes = main.parse(seek: i, string: string)
            if (mainRes.code != .complete) {
                return ParseState(seek: i, code: .splitNotEnoughData)
            }
            i = mainRes.seek
        }

        var mainResSeek = i
        for _ in (range.lowerBound + 1)..<range.upperBound {
            let dividerRes = divider.parse(seek: i, string: string)
            if (dividerRes.code != .complete) {
                return ParseState(seek: mainResSeek, code: .complete)
            }
            i = dividerRes.seek

            let mainRes = main.parse(seek: i, string: string)
            if (mainRes.code != .complete) {
                return ParseState(seek: mainResSeek, code: .complete)
            }
            i = mainRes.seek
            mainResSeek = i
        }

        return ParseState(seek: mainResSeek, code: .complete)
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        var i = seek
        var result = T()

        if (range.lowerBound != 0) {
            for _ in 0..<range.lowerBound {
                let mainRes = main.parseWithResult(seek: i, string: string)
                if (mainRes.state.code != .complete) {
                    return ParseResult(seek: i, code: .splitNotEnoughData)
                }
                i = mainRes.state.seek
                if let res = mainRes.result {
                    result.append(res)
                }

                let dividerRes = divider.parse(seek: i, string: string)
                if (dividerRes.code != .complete) {
                    return ParseResult(seek: i, code: .splitNotEnoughData)
                }
                i = dividerRes.seek
            }

            let mainRes = main.parseWithResult(seek: i, string: string)
            if (mainRes.state.code != .complete) {
                return ParseResult(seek: i, code: .splitNotEnoughData)
            }
            i = mainRes.state.seek
            if let res = mainRes.result {
                result.append(res)
            }
        }

        var mainResSeek = i
        for _ in (range.lowerBound + 1)..<range.upperBound {
            let dividerRes = divider.parse(seek: i, string: string)
            if (dividerRes.code != .complete) {
                return ParseResult(seek: mainResSeek, code: .complete, result: result)
            }
            i = dividerRes.seek

            let mainRes = main.parseWithResult(seek: i, string: string)
            if (mainRes.state.code != .complete) {
                return ParseResult(seek: mainResSeek, code: .complete, result: result)
            }
            i = mainRes.state.seek
            mainResSeek = i
            if let res = mainRes.result {
                result.append(res)
            }
        }

        return ParseResult(seek: mainResSeek, code: .complete, result: result)
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        var i = seek

        if (range.lowerBound != 0) {
            for _ in 0..<range.lowerBound {
                let mainRes = main.parse(seek: i, string: string)
                if (mainRes.code != .complete) {
                    return false
                }
                i = mainRes.seek

                let dividerRes = divider.parse(seek: i, string: string)
                if (dividerRes.code != .complete) {
                    return false
                }
                i = dividerRes.seek
            }

            return main.hasMatch(seek: i, string: string)
        } else {
            return true
        }
    }
}

extension RuleProtocol {
    func split<Divider : RuleProtocol>(divider: Divider, range: ClosedRange<Int>) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: range)
    }

    func split<Divider : RuleProtocol>(divider: Divider, range: Range<Int>) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: range.lowerBound...range.upperBound - 1)
    }

    func split<Divider : RuleProtocol>(divider: Divider, times: Int) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: times...times)
    }

    func split<Divider : RuleProtocol>(divider: Divider, range: PartialRangeFrom<Int>) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: range.lowerBound...Int.max)
    }

    func split<Divider : RuleProtocol>(divider: Divider, range: PartialRangeUpTo<Int>) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: 0...range.upperBound - 1)
    }

    func split<Divider : RuleProtocol>(divider: Divider, range: PartialRangeThrough<Int>) -> SplitRule<Self, Divider> {
        SplitRule(main: self, divider: divider, range: 0...range.upperBound)
    }
}

func %<Main : RuleProtocol, Divider : RuleProtocol>(rule: Main, divider: Divider) -> SplitRule<Main, Divider> {
    rule.split(divider: divider, range: 1...Int.max)
}
