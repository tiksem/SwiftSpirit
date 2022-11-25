//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

struct CharPredicateData {
    let set: CharacterSet
    let matchChar: UnicodeScalar?
    let ranges: [ClosedRange<UnicodeScalar>]
    let inverted: Bool

    init(chars: [UnicodeScalar] = [],
         inString: String = "",
         matchChar: UnicodeScalar? = nil,
         ranges: [ClosedRange<UnicodeScalar>] = [],
         set: CharacterSet = CharacterSet(),
         inverted: Bool
    )
    {
        if matchChar != nil {
            self.matchChar = matchChar
            self.set = set
            self.ranges = ranges
            self.inverted = inverted
            return
        }

        var resultSet: CharacterSet
        if inString.isEmpty && chars.isEmpty {
            resultSet = set
        } else {
            resultSet = set

            for ch in chars {
                resultSet.insert(ch)
            }

            resultSet.insert(charactersIn: inString)
        }

        self.set = resultSet
        self.ranges = ranges
        self.matchChar = matchChar
        self.inverted = inverted
    }

    private func toSet() -> CharacterSet {
        if let char = matchChar {
            return CharacterSet([char])
        }

        if ranges.isEmpty {
            return set
        }

        var set = set
        for range in ranges {
            set.insert(charactersIn: range)
        }

        return set
    }

    private func toSetApplyInverted() -> CharacterSet {
        if inverted {
            return toSet().inverted
        } else {
            return toSet()
        }
    }

    func toPredicate() -> (UnicodeScalar) -> Bool {
        if let char = matchChar {
            if inverted {
                return { $0 != char }
            } else {
                return { $0 == char }
            }
        }

        if ranges.isEmpty {
            if set.isEmpty {
                let r = inverted
                return { _ in r }
            } else if inverted {
                let set = set
                return { !set.contains($0) }
            } else {
                let set = set
                return { set.contains($0) }
            }
        }

        if set.isEmpty {
            if inverted {
                let ranges = ranges
                return { !ranges.containsChar($0) }
            } else {
                let ranges = ranges
                return { !ranges.containsChar($0) }
            }
        }

        let set = set
        let ranges = ranges
        if inverted {
            return { !ranges.containsChar($0) && !set.contains($0) }
        } else {
            let ranges = ranges
            return { ranges.containsChar($0) || set.contains($0) }
        }
    }

    static prefix func !(a: CharPredicateData) -> CharPredicateData {
        CharPredicateData(matchChar: a.matchChar, ranges: a.ranges, set: a.set, inverted: !a.inverted)
    }

    static func -(a: CharPredicateData, b: CharPredicateData) -> CharPredicateData {
        if let aChar = a.matchChar, let bChar = b.matchChar {
            if aChar == bChar {
                if a.inverted == b.inverted {
                    return CharPredicateData(set: CharacterSet(), inverted: false)
                } else {
                    return a
                }
            } else {
                if a.inverted {
                    if b.inverted {
                        return CharPredicateData(matchChar: bChar, inverted: false)
                    } else {
                        return CharPredicateData(chars: [aChar, bChar], inverted: true)
                    }
                } else {
                    if b.inverted {
                        return CharPredicateData(set: CharacterSet(), inverted: false)
                    } else {
                        return a
                    }
                }
            }
        }

        let aSet = a.toSetApplyInverted()
        let bSet = b.toSetApplyInverted()

        return CharPredicateData(set: aSet.subtracting(bSet), inverted: false)
    }

    static func +(a: CharPredicateData, b: CharPredicateData) -> CharPredicateData {
        if let aChar = a.matchChar, let bChar = b.matchChar {
            if aChar == bChar {
                if a.inverted == b.inverted {
                    return a
                } else {
                    return CharPredicateData(set: CharacterSet(), inverted: true)
                }
            } else {
                if a.inverted {
                    if b.inverted {
                        return CharPredicateData(set: CharacterSet(), inverted: true)
                    } else {
                        return a
                    }
                } else {
                    if b.inverted {
                        return b
                    } else {
                        return CharPredicateData(chars: [aChar, bChar], inverted: false)
                    }
                }
            }
        }

        let aSet = a.toSetApplyInverted()
        let bSet = b.toSetApplyInverted()

        return CharPredicateData(set: aSet.union(bSet), inverted: false)
    }
}