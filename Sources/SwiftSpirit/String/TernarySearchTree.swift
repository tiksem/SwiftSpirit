//
// Created by Semyon Tikhonenko on 11/20/22.
//

import Foundation

class TernarySearchTree {
    class Node {
        let char: UnicodeScalar

        init(char: UnicodeScalar) {
            self.char = char
        }

        var eq: Node? = nil
        var left: Node? = nil
        var right: Node? = nil
        var string: String? = nil
    }

    let strings: [String]
    private var root: Node?

    init(strings: [String]) {
        self.strings = strings
        assert(strings.count > 0)

        let firstString = strings[0]
        assert(firstString.count > 0)
    }

    private func compile() {
        guard root == nil else {
            return
        }

        let firstString = strings[0]
        root = Node(char: firstString.unicodeScalars.first!)

        for s in strings {
            if s.isEmpty {
                continue
            }

            let scalars = s.unicodeScalars
            let lastLetterIndex = scalars.index(before: scalars.endIndex)
            insert(node: root!, begin: scalars.startIndex, lastLetterIndex: lastLetterIndex, word: scalars, string: s)
        }
    }

    private func insert(
            node: Node,
            begin: String.Index,
            lastLetterIndex: String.Index,
            word: String.UnicodeScalarView,
            string: String
    ) {
        let ch = word[begin]

        if (node.char == ch) {
            if (begin == lastLetterIndex) {
                node.string = string
            } else {
                let next = word.index(after: begin)
                if let eq = node.eq {
                    insert(node: eq, begin: next, lastLetterIndex: lastLetterIndex, word: word, string: string)
                } else {
                    let eq = Node(char: word[next])
                    node.eq = eq
                    insert(node: eq, begin: next, lastLetterIndex: lastLetterIndex, word: word, string: string)
                }
            }
        } else if (ch < node.char) {
            if let left = node.left {
                insert(node: left, begin: begin, lastLetterIndex: lastLetterIndex, word: word, string: string)
            } else {
                let left = Node(char: ch)
                node.left = left
                insert(node: left, begin: begin, lastLetterIndex: lastLetterIndex, word: word, string: string)
            }
        } else {
            if let right = node.right {
                insert(node: right, begin: begin, lastLetterIndex: lastLetterIndex, word: word, string: string)
            } else {
                let right = Node(char: ch)
                node.right = right
                insert(node: right, begin: begin, lastLetterIndex: lastLetterIndex, word: word, string: string)
            }
        }
    }

    func parse(seek: String.Index, string: String.UnicodeScalarView) -> String.Index? {
        compile()
        return parse(node: root!, seek: seek, string: string)
    }

    private func parse(node: Node, seek: String.Index, string: String.UnicodeScalarView) -> String.Index? {
        guard seek != string.endIndex else {
            return nil
        }

        let ch = string[seek]
        let nodeCh = node.char
        if ch == nodeCh {
            if node.string != nil {
                let next = string.index(after: seek)
                if let eq = node.eq, let moreSearch = parse(node: eq, seek: next, string: string) {
                    return moreSearch
                } else {
                    return next
                }
            } else if let eq = node.eq {
                let next = string.index(after: seek)
                return parse(node: eq, seek: next, string: string)
            } else {
                return nil
            }
        } else if ch < nodeCh {
            guard let left = node.left else {
                return nil
            }

            return parse(node: left, seek: seek, string: string)
        } else {
            guard let right = node.right else {
                return nil
            }

            return parse(node: right, seek: seek, string: string)
        }
    }

    func parseWithResult(
            seek: String.Index,
            string: String.UnicodeScalarView,
            out: inout String?
    ) -> String.Index? {
        compile()
        return parseWithResult(node: root!, seek: seek, string: string, out: &out)
    }

    private func parseWithResult(
            node: Node,
            seek: String.Index,
            string: String.UnicodeScalarView,
            out: inout String?
    ) -> String.Index? {
        guard seek != string.endIndex else {
            return nil
        }

        let ch = string[seek]
        let nodeCh = node.char
        if ch == nodeCh {
            if let str = node.string {
                let next = string.index(after: seek)
                if let eq = node.eq, let moreSearch = parseWithResult(node: eq, seek: next, string: string, out: &out) {
                    return moreSearch
                } else {
                    out = str
                    return next
                }
            } else if let eq = node.eq {
                let next = string.index(after: seek)
                return parseWithResult(node: eq, seek: next, string: string, out: &out)
            } else {
                return nil
            }
        } else if ch < nodeCh {
            guard let left = node.left else {
                return nil
            }

            return parseWithResult(node: left, seek: seek, string: string, out: &out)
        } else {
            guard let right = node.right else {
                return nil
            }

            return parseWithResult(node: right, seek: seek, string: string, out: &out)
        }
    }

    private func hasMatch(node: Node,
                          seek: String.Index,
                          string: String.UnicodeScalarView) -> Bool {
        if seek == string.endIndex {
            return false
        }

        let ch = string[seek]
        let nodeCh = node.char
        if ch == nodeCh {
            if (node.string != nil) {
                return true
            } else {
                if let eq = node.eq {
                    return hasMatch(node: eq, seek: string.index(after: seek), string: string)
                } else {
                    return false
                }
            }
        } else if ch < nodeCh {
            if let left = node.left {
                return hasMatch(node: left, seek: seek, string: string)
            } else {
                return false
            }
        } else {
            if let right = node.right {
                return hasMatch(node: right, seek: seek, string: string)
            } else {
                return false
            }
        }
    }

    func hasMatch(seek: String.Index, string: String.UnicodeScalarView) -> Bool {
        compile()
        return hasMatch(node: root!, seek: seek, string: string)
    }
}