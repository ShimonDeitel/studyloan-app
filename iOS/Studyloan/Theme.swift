import SwiftUI

enum Theme {
    static let accent = Color(red: 0.239, green: 0.353, blue: 0.502)
    static let background = Color(red: 0.059, green: 0.090, blue: 0.125)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)
}
