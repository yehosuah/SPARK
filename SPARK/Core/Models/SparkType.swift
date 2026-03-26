import Foundation

enum StimulusFamily: String, Codable, CaseIterable, Identifiable, Hashable {
    case artifact
    case caseStudy = "case"
    case contrast
    case pattern
    case collision

    var id: String { rawValue }

    var title: String {
        switch self {
        case .artifact:
            return "Artifact"
        case .caseStudy:
            return "Case"
        case .contrast:
            return "Contrast"
        case .pattern:
            return "Pattern"
        case .collision:
            return "Collision"
        }
    }

    var shortDescription: String {
        switch self {
        case .artifact:
            return "Concrete creative object"
        case .caseStudy:
            return "Real-world lesson"
        case .contrast:
            return "Side-by-side tension"
        case .pattern:
            return "Reusable mechanism"
        case .collision:
            return "Unexpected synthesis"
        }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = StimulusFamily(storageValue: rawValue) ?? .artifact
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    init?(storageValue: String) {
        switch storageValue {
        case "artifact", "seed", "prompt":
            self = .artifact
        case "case", "caseStudy":
            self = .caseStudy
        case "contrast", "reframe":
            self = .contrast
        case "pattern", "observation":
            self = .pattern
        case "collision":
            self = .collision
        default:
            return nil
        }
    }
}
