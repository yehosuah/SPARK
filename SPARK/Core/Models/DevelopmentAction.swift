import Foundation

enum DevelopmentAction: String, CaseIterable, Codable, Identifiable, Hashable {
    case reframe
    case findTension
    case makeBolder
    case makeMoreOriginal
    case turnIntoConcept
    case connectToDomain
    case namePrinciple
    case changeScale

    var id: String { rawValue }

    var title: String {
        switch self {
        case .reframe:
            return "Reframe"
        case .findTension:
            return "Find the tension"
        case .makeBolder:
            return "Make bolder"
        case .makeMoreOriginal:
            return "Make more original"
        case .turnIntoConcept:
            return "Turn into concept"
        case .connectToDomain:
            return "Connect to domain"
        case .namePrinciple:
            return "Name the principle"
        case .changeScale:
            return "Change the scale"
        }
    }
}
