//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

extension Array where Element == ClosedRange<Character> {
    func contains(char: Character) -> Bool {
        contains { range in range.contains(char) }
    }
}