//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

enum ParseCode {
    case complete,
         invalidInt,
         intOverflow,
         invalidFloat,
         charPredicateFailed,
         numberStartedFromZero,
         diffFailed,
         repeatNotEnoughData,
         splitNotEnoughData,
         exactStringNoMatch,
         predicateStringNotEnoughData,
         onOfStringNoMatch,
         eof,
         invalidRule;
}
