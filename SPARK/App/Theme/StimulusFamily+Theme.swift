import SwiftUI

extension StimulusFamily {
    var accentColor: Color {
        switch self {
        case .artifact:
            return ColorTokens.artifactAccent
        case .caseStudy:
            return ColorTokens.caseAccent
        case .contrast:
            return ColorTokens.contrastAccent
        case .pattern:
            return ColorTokens.patternAccent
        case .collision:
            return ColorTokens.collisionAccent
        }
    }

    var washColor: Color {
        switch self {
        case .artifact:
            return ColorTokens.artifactWash
        case .caseStudy:
            return ColorTokens.caseWash
        case .contrast:
            return ColorTokens.contrastWash
        case .pattern:
            return ColorTokens.patternWash
        case .collision:
            return ColorTokens.collisionWash
        }
    }

    var shelfCardWidth: CGFloat {
        switch self {
        case .artifact, .contrast:
            return 334
        case .caseStudy, .pattern:
            return 290
        case .collision:
            return 308
        }
    }
}
