import SwiftUI

extension View {
    func sparkScreenBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background {
                ZStack {
                    ColorTokens.canvas
                    SPARKTheme.backgroundGradient
                    SPARKTheme.studioGlow
                    SPARKTheme.lowerWash
                }
                .ignoresSafeArea()
            }
    }
}
