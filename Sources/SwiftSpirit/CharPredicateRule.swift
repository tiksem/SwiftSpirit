//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

class CharPredicateRule : RuleProtocol {
    typealias T = UnicodeScalar

    let predicate: (UnicodeScalar) -> Bool
    let data: CharPredicateData?

    init(predicate: @escaping (UnicodeScalar) -> Bool, data: CharPredicateData? = nil) {
        self.predicate = predicate
        self.data = data
    }

    func parse(seek: String.Index, string: Data) -> ParseState {
        guard seek != string.endIndex else {
            return ParseState(seek: seek, code: .eof)
        }

        let ch = string.scalars[seek]
        if (predicate(ch)) {
            return ParseState(seek: string.scalars.index(after: seek), code: .complete)
        } else {
            return ParseState(seek: seek, code: .charPredicateFailed)
        }
    }

    func parseWithResult(seek: String.Index, string: Data) -> ParseResult<T> {
        guard seek != string.endIndex else {
            return ParseResult(seek: seek, code: .eof)
        }

        let ch = string.scalars[seek]
        if (predicate(ch)) {
            return ParseResult(seek: string.scalars.index(after: seek), code: .complete, result: ch)
        } else {
            return ParseResult(seek: seek, code: .charPredicateFailed)
        }
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

func |(a: CharPredicateRule, b: CharacterSet) -> CharPredicateRule {
    if let aData = a.data {
        let data = aData + CharPredicateData(set: b)
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }

    return CharPredicateRule(predicate: {
        a.predicate($0) || b.contains($0)
    })
}

func |(a: CharacterSet, b: CharPredicateRule) -> CharPredicateRule {
    b | a
}

func |(a: AnyCharRule, b: CharPredicateRule) -> AnyCharRule {
    a
}

func |(a: AnyCharRule, b: CharacterSet) -> AnyCharRule {
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

func -(a: CharPredicateRule, b: CharacterSet) -> CharPredicateRule {
    if let aData = a.data {
        let data = aData - CharPredicateData(set: b)
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }

    return CharPredicateRule(predicate: {
        a.predicate($0) && !b.contains($0)
    })
}

func -(a: CharacterSet, b: CharPredicateRule) -> CharPredicateRule {
    if let bData = b.data {
        let data = CharPredicateData(set: a) - bData
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }

    return CharPredicateRule(predicate: {
        a.contains($0) && !b.predicate($0)
    })
}

func -(a: CharPredicateRule, b: UnicodeScalar) -> CharPredicateRule {
    if let aData = a.data {
        let data = aData - CharPredicateData(singleChar: b)
        return CharPredicateRule(predicate: data.toPredicate(), data: data)
    }

    return CharPredicateRule(predicate: {
        $0 != b && a.predicate($0)
    })
}