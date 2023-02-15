//
// Created by Semyon Tikhonenko on 2/15/23.
//

import Foundation

protocol ResultHookProtocol {
    associatedtype T
    func submit(value: T?)
    func clear()
}

class ResultHook<T> : ResultHookProtocol {
    private(set) var value: T?

    func submit(value: T?) {
        self.value = value
    }

    func clear() {
        value = nil
    }
}

class ResultArrayHook<T> : ResultHookProtocol {
    private(set) var array = [T]()

    func submit(value: T?) {
        if let v = value {
            array.append(v)
        }
    }

    func clear() {
        array = []
    }
}