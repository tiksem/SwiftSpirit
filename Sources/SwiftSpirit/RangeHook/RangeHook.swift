//
// Created by Semyon Tikhonenko on 11/26/22.
//

import Foundation

public protocol RangeHookProtocol {
    func submit(range: Range<String.Index>)
    func clear()
}

public class RangeHook : RangeHookProtocol {
    private(set) var range: Range<String.Index>?

    public func submit(range: Range<String.Index>) {
        self.range = range
    }

    public func clear() {
        range = nil
    }
}

public class ArrayRangeHook : RangeHookProtocol {
    private(set) var ranges: [Range<String.Index>] = []

    public func submit(range: Range<String.Index>) {
        ranges.append(range)
    }

    public func clear() {
        ranges = []
    }
}