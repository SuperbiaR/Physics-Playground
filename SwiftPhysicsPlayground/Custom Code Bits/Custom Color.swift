public struct Color {
    public var r, g, b, a: UInt8

    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

// Create Custom Colors Here
public extension Color {
    static let clear = Color(r: 0, g: 0, b: 0, a: 0)
    static let backgroundGray = Color(r: 38, g: 38, b: 38, a: 1)
    static let debugRed = Color(r: 100, g: 0, b: 0, a: 1)
}
