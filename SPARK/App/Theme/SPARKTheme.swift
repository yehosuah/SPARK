import SwiftUI

enum SPARKTheme {
    static let backgroundGradient = LinearGradient(
        colors: [
            ColorTokens.canvas,
            ColorTokens.pageWarm
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let studioGlow = RadialGradient(
        colors: [
            ColorTokens.page.opacity(0.95),
            ColorTokens.page.opacity(0.0)
        ],
        center: .topLeading,
        startRadius: 40,
        endRadius: 520
    )

    static let lowerWash = LinearGradient(
        colors: [
            Color.clear,
            ColorTokens.overlayScrim
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
