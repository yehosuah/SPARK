import Foundation

enum DevelopmentActionPrompts {
    static func instruction(for action: DevelopmentAction, domainTitle: String?) -> String {
        switch action {
        case .reframe:
            return "Offer a different framing that changes what the idea is really about."
        case .findTension:
            return "Expose the conflict, contradiction, or tradeoff that makes the idea worth pursuing."
        case .makeBolder:
            return "Push the stance toward something more opinionated and harder to ignore."
        case .makeMoreOriginal:
            return "Move the note away from familiar language and toward a less expected move."
        case .turnIntoConcept:
            return "Translate the raw note into a concept someone could name, describe, and build around."
        case .connectToDomain:
            return "Connect the idea to \(domainTitle ?? "another domain the writer cares about") without making it generic."
        case .namePrinciple:
            return "Name the underlying principle the note is circling."
        case .changeScale:
            return "Shift the idea to a different scale: smaller, larger, more personal, or more systemic."
        }
    }
}
