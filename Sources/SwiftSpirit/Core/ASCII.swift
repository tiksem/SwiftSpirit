//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

struct ASCII {
    static let digits: ClosedRange<UInt8> = 48...57
    static let plus: UInt8 = 43
    static let minus: UInt8 = 45
    static let dot: UInt8 = 46
    static let e: UInt8 = 101
    static let E: UInt8 = 69
}

extension UnicodeScalar {
    func toDigit() -> Int {
        Int(value - 48)
    }
}

extension UInt8 {
    func toDigit() -> Int {
        Int(self - 48)
    }

    func isDigit() -> Bool {
        ASCII.digits.contains(self)
    }
}