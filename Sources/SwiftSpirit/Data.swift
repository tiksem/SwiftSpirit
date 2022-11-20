//
// Created by Semyon Tikhonenko on 11/19/22.
//

import Foundation

struct Data {
    let original: String
    let utf8: String.UTF8View
    let scalars: String.UnicodeScalarView
    let startIndex: String.Index
    let endIndex: String.Index

    init(string: String) {
        self.original = string
        utf8 = string.utf8
        scalars = string.unicodeScalars
        startIndex = string.startIndex
        endIndex = string.endIndex
    }
}
