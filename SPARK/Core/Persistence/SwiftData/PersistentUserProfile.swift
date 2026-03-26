import Foundation
import SwiftData

@Model
final class PersistentUserProfile {
    @Attribute(.unique) var id: UUID
    var interestsJSON: String
    var creativeIntentsJSON: String
    var preferredCaptureModeRaw: String
    var creativeRhythmRaw: String
    var onboardingCompleted: Bool
    var updatedAt: Date

    init(
        id: UUID,
        interestsJSON: String,
        creativeIntentsJSON: String,
        preferredCaptureModeRaw: String,
        creativeRhythmRaw: String,
        onboardingCompleted: Bool,
        updatedAt: Date
    ) {
        self.id = id
        self.interestsJSON = interestsJSON
        self.creativeIntentsJSON = creativeIntentsJSON
        self.preferredCaptureModeRaw = preferredCaptureModeRaw
        self.creativeRhythmRaw = creativeRhythmRaw
        self.onboardingCompleted = onboardingCompleted
        self.updatedAt = updatedAt
    }
}
