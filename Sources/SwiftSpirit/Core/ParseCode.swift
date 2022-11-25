//
// Created by Semyon Tikhonenko on 11/18/22.
//

import Foundation

public enum ParseCode {
    case complete,
         invalidInt,
         intOverflow,
         uintOverflow,
         invalidFloat,
         charPredicateFailed,
         numberStartedFromZero,
         diffFailed,
         repeatNotEnoughData,
         splitNotEnoughData,
         exactStringNoMatch,
         predicateStringNotEnoughData,
         oneOfStringNoMatch,
         eof,
         invalidRule;

    func toError(seek: String.Index) -> ParseError {
        switch self {
        case .complete:
            return .complete(seek: seek)
        case .invalidInt:
            return .invalidInt(seek: seek)
        case .intOverflow:
            return .intOverflow(seek: seek)
        case .uintOverflow:
            return .uintOverflow(seek: seek)
        case .invalidFloat:
            return .invalidFloat(seek: seek)
        case .charPredicateFailed:
            return .charPredicateFailed(seek: seek)
        case .numberStartedFromZero:
            return .intStartedFromZero(seek: seek)
        case .diffFailed:
            return .diffFailed(seek: seek)
        case .repeatNotEnoughData:
            return .repeatNotEnoughData(seek: seek)
        case .splitNotEnoughData:
            return .splitNotEnoughData(seek: seek)
        case .exactStringNoMatch:
            return .exactStringNoMatch(seek: seek)
        case .predicateStringNotEnoughData:
            return .predicateStringNotEnoughData(seek: seek)
        case .oneOfStringNoMatch:
            return .oneOfStringNoMatch(seek: seek)
        case .eof:
            return .eof(seek: seek)
        case .invalidRule:
            return .invalidRule(seek: seek)
        }
    }
}
