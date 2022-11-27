//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class CharPredicateRule : Rule<UnicodeScalar> {
    let predicate: (UnicodeScalar) -> Bool
    let data: CharPredicateData?

    init(predicate: @escaping (UnicodeScalar) -> Bool, data: CharPredicateData? = nil, name: String? = nil) {
        self.predicate = predicate
        self.data = data
        #if DEBUG
        super.init(name: name ?? data?.getName() ?? "charIf")
        #endif
    }

    override func parse(seek: String.Index, string: String) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        let ch = string.unicodeScalars[seek]
        if (predicate(ch)) {
            return ParseState(seek: string.unicodeScalars.index(after: seek), code: .complete)
        } else {
            return ParseState(seek: seek, code: .charPredicateFailed)
        }
    }

    override func parseWithResult(seek: String.Index, string: String) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        let ch = string.unicodeScalars[seek]
        if (predicate(ch)) {
            return ParseResult(seek: string.unicodeScalars.index(after: seek), code: .complete, result: ch)
        } else {
            return ParseResult(seek: seek, code: .charPredicateFailed)
        }
    }

    override func name(name: String) -> CharPredicateRule {
        CharPredicateRule(predicate: predicate, data: data, name: name)
    }
}

func |(a: CharPredicateRule, b: CharPredicateRule) -> CharPredicateRule {
    if let aData = a.data, let bData = b.data {
        let data = aData + bData
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    } else {
        return CharPredicateRule(predicate: {
            a.predicate($0) || b.predicate($0)
        })
    }
}

func |(a: CharPredicateRule, b: UnicodeScalar) -> CharPredicateRule {
    a | char(b)
}

func |(a: UnicodeScalar, b: CharPredicateRule) -> CharPredicateRule {
    char(a) | b
}

func |(a: AnyCharRule, b: CharPredicateRule) -> AnyCharRule {
    a
}

func -(a: CharPredicateRule, b: CharPredicateRule) -> CharPredicateRule {
    if let aData = a.data, let bData = b.data {
        let data = aData - bData
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    } else {
        return CharPredicateRule(predicate: {
            a.predicate($0) && !b.predicate($0)
        })
    }
}

func -(a: CharPredicateRule, b: UnicodeScalar) -> CharPredicateRule {
    if let aData = a.data {
        let data = aData - CharPredicateData(matchChar: b, inverted: false)
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }

    return CharPredicateRule(predicate: {
        $0 != b && a.predicate($0)
    })
}

func -(a: AnyCharRule, b: UnicodeScalar) -> CharPredicateRule {
    let data = CharPredicateData(matchChar: b, inverted: true)
    return CharPredicateRule(predicate: data.toPredicate(), data: data)
}

func -(a: AnyCharRule, b: CharPredicateRule) -> CharPredicateRule {
    if let bData = b.data {
        let data = !bData
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    } else {
        return CharPredicateRule(predicate: { !b.predicate($0) }, data: nil)
    }
}