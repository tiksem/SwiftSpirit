//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

class SplitRule<T, D> : Rule<[T]> {
    let main: Rule<T>
    let divider: Rule<D>
    let range: ClosedRange<Int>

    init(main: Rule<T>, divider: Rule<D>, range: ClosedRange<Int>, name: String? = nil) {
        self.main = main
        self.divider = divider
        self.range = range
        #if DEBUG
        super.init(name: name ?? "\(main.wrappedName).split(\(divider.name),\(range.getNameToken()))")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
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

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<[T]> {
        var i = seek
        var result = [T]()

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

    func hasMatch(seek: String.Index, string: String) -> Bool {
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

    override func clone() -> SplitRule<T, D> {
        SplitRule(main: main.clone(), divider: divider.clone(), range: range, name: name)
    }

    override func name(name: String) -> SplitRule<T, D> {
        SplitRule(main: main, divider: divider, range: range, name: name)
    }

    #if DEBUG
    override func debug(context: DebugContext) -> DebugRule<[T]> {
        let base = SplitRule(main: main.debug(context: context),
                divider: divider.debug(context: context), range: range, name: name)
        return DebugRule(base: base, context: context)
    }
    #endif
}

extension Rule {
    func split<D>(divider: Rule<D>, range: ClosedRange<Int>) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: range)
    }

    func split<D>(divider: Rule<D>, range: Range<Int>) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: range.toClosed())
    }

    func split<D>(divider: Rule<D>, times: Int) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: times...times)
    }

    func split<D>(divider: Rule<D>, range: PartialRangeFrom<Int>) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: range.toClosed())
    }

    func split<D>(divider: Rule<D>, range: PartialRangeUpTo<Int>) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: range.toClosed())
    }

    func split<D>(divider: Rule<D>, range: PartialRangeThrough<Int>) -> SplitRule<T, D> {
        SplitRule(main: self, divider: divider, range: range.toClosed())
    }

    func split(divider: String, range: ClosedRange<Int>) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: range)
    }

    func split(divider: String, range: Range<Int>) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: range.toClosed())
    }

    func split(divider: String, times: Int) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: times...times)
    }

    func split(divider: String, range: PartialRangeFrom<Int>) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: range.toClosed())
    }

    func split(divider: String, range: PartialRangeUpTo<Int>) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: range.toClosed())
    }

    func split(divider: String, range: PartialRangeThrough<Int>) -> SplitRule<T, String> {
        SplitRule(main: self, divider: str(divider), range: range.toClosed())
    }
}

func %<T, D>(rule: Rule<T>, divider: Rule<D>) -> SplitRule<T, D> {
    rule.split(divider: divider, range: 1...Int.max)
}

func %<T>(rule: Rule<T>, divider: String) -> SplitRule<T, String> {
    rule.split(divider: divider, range: 1...Int.max)
}
