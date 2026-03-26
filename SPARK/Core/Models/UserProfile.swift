import Foundation

enum CreativeRhythm: String, Codable, CaseIterable, Identifiable, Hashable {
    case dailySparks
    case freeExplore
    case both

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dailySparks:
            return "Give me a few strong sparks each day"
        case .freeExplore:
            return "Let me explore freely when I want"
        case .both:
            return "Both"
        }
    }
}

struct UserProfile: Identifiable, Codable, Equatable {
    var id: UUID
    var interests: [InterestDomain]
    var creativeIntents: [CreativeIntent]
    var preferredCaptureMode: CaptureMode
    var creativeRhythm: CreativeRhythm
    var onboardingCompleted: Bool
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        interests: [InterestDomain] = [],
        creativeIntents: [CreativeIntent] = [],
        preferredCaptureMode: CaptureMode = .write,
        creativeRhythm: CreativeRhythm = .both,
        onboardingCompleted: Bool = false,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.interests = interests
        self.creativeIntents = creativeIntents
        self.preferredCaptureMode = preferredCaptureMode
        self.creativeRhythm = creativeRhythm
        self.onboardingCompleted = onboardingCompleted
        self.updatedAt = updatedAt
    }
}
