//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

struct CharPredicateData {
    let set: CharacterSet
    // Characters containing more than one scalar
    let singleChar: UnicodeScalar?

    init(set: CharacterSet) {
        self.set = set
        self.singleChar = nil
    }

    init(singleChar: UnicodeScalar) {
        self.singleChar = singleChar
        set = CharacterSet()
    }

    init(chars: [UnicodeScalar] = [],
         inString: String = "",
         ranges: [ClosedRange<UnicodeScalar>] = [],
         set: CharacterSet = CharacterSet())
    {
        var resultSet = CharacterSet()

        for ch in chars {
            resultSet.insert(ch)
        }

        for range in ranges {
            resultSet.insert(charactersIn: range)
        }

        resultSet.insert(charactersIn: inString)
        self.set = resultSet.union(set)
        singleChar = nil
    }

    init(char: UnicodeScalar) {
        singleChar = char
        set = CharacterSet()
    }

    func toPredicate() -> (UnicodeScalar) -> Bool {
        if let char = singleChar {
            return { $0 == char }
        }

        if (set.isEmpty) {
            return { _ in false }
        } else {
            return { set.contains($0) }
        }
    }

    static func + (a: CharPredicateData, b: CharPredicateData) -> CharPredicateData {
        if let a = a.singleChar, let b = b.singleChar {
            return CharPredicateData(chars: [a, b])
        }

        if let aChar = a.singleChar {
            return CharPredicateData(chars: [aChar]) + b
        }

        if let bChar = b.singleChar {
            return CharPredicateData(chars: [bChar]) + a
        }

        return CharPredicateData(set: a.set.union(b.set))
    }

    static func - (a: CharPredicateData, b: CharPredicateData) -> CharPredicateData {
        if let aChar = a.singleChar, let bChar = b.singleChar {
            if (aChar == bChar) {
                return CharPredicateData(set: CharacterSet())
            } else {
                return a
            }
        }

        if let aChar = a.singleChar {
            return CharPredicateData(chars: [aChar]) - b
        }

        if let bChar = b.singleChar {
            return a - CharPredicateData(chars: [bChar])
        }

        return CharPredicateData(set: a.set.subtracting(b.set))
    }
}