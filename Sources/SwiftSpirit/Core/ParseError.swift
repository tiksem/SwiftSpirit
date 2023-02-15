//
// Created by Semyon Tikhonenko on 11/25/22.
//

import Foundation

enum ParseError : Error {
    case invalidInt(seek: String.Index)
    case intOverflow(seek: String.Index)
    case uintOverflow(seek: String.Index)
    case invalidFloat(seek: String.Index)
    case decimalOverflow(seek: String.Index)
    case charPredicateFailed(seek: String.Index)
    case intStartedFromZero(seek: String.Index)
    case diffFailed(seek: String.Index)
    case repeatNotEnoughData(seek: String.Index)
    case splitNotEnoughData(seek: String.Index)
    case exactStringNoMatch(seek: String.Index)
    case predicateStringNotEnoughData(seek: String.Index)
    case oneOfStringNoMatch(seek: String.Index)
    case expectationFailed(seek: String.Index)
    case noFailed(seek: String.Index)
    case eof(seek: String.Index)
    case invalidRule(seek: String.Index)
    case invalidUnicodeScalarsSeek(seek: String.Index);
}
