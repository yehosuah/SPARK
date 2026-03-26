import Foundation

enum InterestDomain: String, Codable, CaseIterable, Identifiable, Hashable {
    case technology
    case ai
    case startups
    case product
    case finance
    case markets
    case design
    case branding
    case psychology
    case philosophy
    case writing
    case storytelling
    case systems
    case strategy
    case culture
    case futureTrends

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ai:
            return "AI"
        case .futureTrends:
            return "Future Trends"
        default:
            return rawValue.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
                .capitalized
        }
    }
}
