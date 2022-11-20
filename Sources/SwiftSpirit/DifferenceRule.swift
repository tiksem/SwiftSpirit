//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class DifferenceRule<Main, Diff> : RuleProtocol where Main : RuleProtocol, Diff : RuleProtocol{
    typealias T = Main.T

    private let main: Main
    private let diff: Diff

    init(main: Main, diff: Diff) {
        self.main = main
        self.diff = diff
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        let mainRes = main.parse(seek: seek, string: string)
        guard mainRes.code == .complete else {
            return mainRes
        }

        if diff.hasMatch(seek: seek, string: string) {
            return ParseState(seek: seek, code: .diffFailed)
        }

        return mainRes
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        let mainRes = main.parseWithResult(seek: seek, string: string)
        guard mainRes.state.code == .complete else {
            return mainRes
        }

        if diff.hasMatch(seek: seek, string: string) {
            return ParseResult(seek: seek, code: .diffFailed)
        }

        return mainRes
    }

    func hasMatch(seek: String.Index, string: Data) -> Bool {
        main.hasMatch(seek: seek, string: string) && !diff.hasMatch(seek: seek, string: string)
    }
}

func -<A: RuleProtocol, B : RuleProtocol> (a: A, b: B) -> DifferenceRule<A, B> {
    DifferenceRule<A, B>(main: a, diff: b)
}
