import SwiftUI

enum MotionTokens {
    static let pageSettle = Animation.easeOut(duration: 0.24)
    static let objectHandoff = Animation.spring(response: 0.38, dampingFraction: 0.88)
    static let inlineReveal = Animation.easeInOut(duration: 0.2)
    static let quietDismiss = Animation.easeOut(duration: 0.16)
    static let acknowledgement = Animation.spring(response: 0.3, dampingFraction: 0.92)

    static let ease = pageSettle
    static let spring = objectHandoff
    static let subtle = inlineReveal
}
