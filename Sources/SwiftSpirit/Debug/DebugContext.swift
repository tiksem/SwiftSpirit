//
// Created by Semyon Tikhonenko on 11/23/22.
//

import Foundation

public struct Seek {
    let utf8Position: Int
    let utf16Position: Int
    let scalarsPosition: Int
    let stringPosition: Int
    let index: String.Index

    init(index: String.Index, data: Data) {
        utf8Position = data.utf8.distance(from: data.startIndex, to: index)
        utf16Position = data.original.utf16.distance(from: data.startIndex, to: index)
        scalarsPosition = data.scalars.distance(from: data.startIndex, to: index)
        stringPosition = data.original.distance(from: data.startIndex, to: index)
        self.index = index
    }
}

open class DebugTreeNode {
    public let name: String
    public let startSeek: Seek
    public internal(set) var parseCode: ParseCode? = nil
    public internal(set) var endSeek: Seek? = nil
    public internal(set) var result: Any? = nil
    public internal(set) var parent: DebugTreeNode? = nil
    public internal(set) var children: [DebugTreeNode] = []

    init(name: String, startSeek: Seek, endSeek: Seek?) {
        self.name = name
        self.startSeek = startSeek
        self.endSeek = endSeek
    }
}

class DebugContext {
    private let data: Data
    private var root: DebugTreeNode? = nil
    private var current: DebugTreeNode? = nil

    init(data: Data) {
        self.data = data
    }

    func parseStarted(name: String, seek: String.Index) {
        let startSeek = Seek(index: seek, data: data)
        let newNode = DebugTreeNode(name: name, startSeek: startSeek, endSeek: nil)
        if let node = current {
            node.children.append(newNode)
            newNode.parent = node
            current = newNode
        } else {
            current = newNode
            root = current
        }
    }
    func parseFinished(endSeek: String.Index, code: ParseCode, result: Any?) {
        current!.endSeek = Seek(index: endSeek, data: data)
        current!.parseCode = code
        current!.result = result

        if current !== root {
            current = current!.parent
        }
    }
}