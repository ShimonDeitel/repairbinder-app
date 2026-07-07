import SwiftUI

/// Repair Bill Binder — bespoke palette tuned to its domain.
enum Theme {
    static let accent = Color(red: 0.878, green: 0.478, blue: 0.122)
    static let background = Color(red: 0.110, green: 0.071, blue: 0.039)
    static let cardBackground = Color(.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}
