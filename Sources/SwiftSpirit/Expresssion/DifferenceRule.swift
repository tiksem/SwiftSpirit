//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class DifferenceRule<Main, Diff> : Rule<Main> {
    private let main: Rule<Main>
    private let diff: Rule<Diff>

    init(main: Rule<Main>, diff: Rule<Diff>, name: String? = nil) {
        self.main = main
        self.diff = diff
        #if DEBUG
        super.init(name: name ?? "\(main.wrappedName)-\(diff.wrappedName)")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        let mainRes = main.parse(seek: seek, string: string)
        guard mainRes.code == .complete else {
            return mainRes
        }

        if diff.hasMatch(seek: seek, string: string) {
            return ParseState(seek: seek, code: .diffFailed)
        }

        return mainRes
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        let mainRes = main.parseWithResult(seek: seek, string: string)
        guard mainRes.state.code == .complete else {
            return mainRes
        }

        if diff.hasMatch(seek: seek, string: string) {
            return ParseResult(seek: seek, code: .diffFailed)
        }

        return mainRes
    }

    func hasMatch(seek: String.Index, string: String) -> Bool {
        main.hasMatch(seek: seek, string: string) && !diff.hasMatch(seek: seek, string: string)
    }

    override func clone() -> DifferenceRule<Main, Diff> {
        DifferenceRule(main: main.clone(), diff: diff.clone(), name: name)
    }

    override func name(name: String) -> DifferenceRule<Main, Diff> {
        DifferenceRule(main: main, diff: diff, name: name)
    }

    #if DEBUG
    override var nameShouldBeWrapped: Bool {
        get { true }
    }

    override func debug(context: DebugContext) -> DebugRule<T> {
        DebugRule(base: DifferenceRule(
                main: main.debug(context: context),
                diff: diff.debug(context: context),
                name: name
        ), context: context)
    }
    #endif
}

func -<A, B> (a: Rule<A>, b: Rule<B>) -> DifferenceRule<A, B> {
    DifferenceRule<A, B>(main: a, diff: b)
}
