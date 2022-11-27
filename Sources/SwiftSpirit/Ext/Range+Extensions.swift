//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

extension Range where Bound : SignedInteger {
    func toClosed() -> ClosedRange<Bound> {
        lowerBound...(upperBound - 1)
    }
}

extension PartialRangeFrom where Bound : SignedInteger & FixedWidthInteger {
    func toClosed() -> ClosedRange<Bound> {
        lowerBound...Bound.max
    }
}

extension PartialRangeUpTo where Bound : SignedInteger {
    func toClosed() -> ClosedRange<Bound> {
        0...(upperBound - 1)
    }
}

extension PartialRangeThrough where Bound : SignedInteger {
    func toClosed() -> ClosedRange<Bound> {
        0...upperBound
    }
}

extension ClosedRange where Bound : SignedInteger {
    func getNameToken() -> String {
        if lowerBound == 0 {
            if upperBound == Int.max {
                return "0..."
            } else {
                return "...\(upperBound)"
            }
        } else if upperBound == Int.max {
            return "\(lowerBound)..."
        } else {
            return description
        }
    }
}

extension Array where Element == ClosedRange<UnicodeScalar> {
    func containsChar(_ ch: UnicodeScalar) -> Bool {
        self.contains(where: { $0.contains(ch) })
    }
}