import Foundation

enum CreativeIntent: String, Codable, CaseIterable, Identifiable, Hashable {
    case moreOriginalIdeas
    case sharperInsight
    case moreArtisticIntention
    case betterProductThinking
    case strongerTaste
    case betterStrategicThinking
    case moreMentalClarity
    case lessOverwhelm
    case betterBusinessIdeas
    case moreExpressiveThinking
    case moreCuriosity
    case moreConceptualDepth

    var id: String { rawValue }

    var title: String {
        switch self {
        case .moreOriginalIdeas:
            return "More original ideas"
        case .sharperInsight:
            return "Sharper insight"
        case .moreArtisticIntention:
            return "More artistic intention"
        case .betterProductThinking:
            return "Better product thinking"
        case .strongerTaste:
            return "Stronger taste"
        case .betterStrategicThinking:
            return "Better strategic thinking"
        case .moreMentalClarity:
            return "More mental clarity"
        case .lessOverwhelm:
            return "Less overwhelm"
        case .betterBusinessIdeas:
            return "Better business ideas"
        case .moreExpressiveThinking:
            return "More expressive thinking"
        case .moreCuriosity:
            return "More curiosity"
        case .moreConceptualDepth:
            return "More conceptual depth"
        }
    }
}
