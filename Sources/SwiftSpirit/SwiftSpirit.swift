public struct SwiftSpirit {
    public private(set) var text = "Hello, World!"

    public init() {
        print(text)

        let flags = "🇦🇺🇦🇽"

        print(flags.utf8.count)
    }
}
