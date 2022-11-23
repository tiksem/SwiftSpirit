//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class DifferenceRule<Main, Diff> : BaseRule<Main> {
    private let main: BaseRule<Main>
    private let diff: BaseRule<Diff>

    init(main: BaseRule<Main>, diff: BaseRule<Diff>) {
        self.main = main
        self.diff = diff
    }

    override func parse(seek: String.Index, string: Data) -> ParseState {
        let mainRes = main.parse(seek: seek, string: string)
        guard mainRes.code == .complete else {
            return mainRes
        }

        if diff.hasMatch(seek: seek, string: string) {
            return ParseState(seek: seek, code: .diffFailed)
        }

        return mainRes
    }

    override func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
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

func -<A, B> (a: BaseRule<A>, b: BaseRule<B>) -> DifferenceRule<A, B> {
    DifferenceRule<A, B>(main: a, diff: b)
}
