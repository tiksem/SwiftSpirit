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

extension Array where Element == ClosedRange<UnicodeScalar> {
    func containsChar(_ ch: UnicodeScalar) -> Bool {
        self.contains(where: { $0.contains(ch) })
    }
}