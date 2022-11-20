//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

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