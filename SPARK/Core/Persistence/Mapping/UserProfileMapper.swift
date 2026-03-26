import Foundation

enum UserProfileMapper {
    static func toDomain(_ persistent: PersistentUserProfile) -> UserProfile {
        UserProfile(
            id: persistent.id,
            interests: decode(persistent.interestsJSON, fallback: []),
            creativeIntents: decode(persistent.creativeIntentsJSON, fallback: []),
            preferredCaptureMode: CaptureMode(rawValue: persistent.preferredCaptureModeRaw) ?? .write,
            creativeRhythm: CreativeRhythm(rawValue: persistent.creativeRhythmRaw) ?? .both,
            onboardingCompleted: persistent.onboardingCompleted,
            updatedAt: persistent.updatedAt
        )
    }

    static func update(_ persistent: PersistentUserProfile, with profile: UserProfile) {
        persistent.interestsJSON = encode(profile.interests)
        persistent.creativeIntentsJSON = encode(profile.creativeIntents)
        persistent.preferredCaptureModeRaw = profile.preferredCaptureMode.rawValue
        persistent.creativeRhythmRaw = profile.creativeRhythm.rawValue
        persistent.onboardingCompleted = profile.onboardingCompleted
        persistent.updatedAt = profile.updatedAt
    }

    static func makePersistent(from profile: UserProfile) -> PersistentUserProfile {
        PersistentUserProfile(
            id: profile.id,
            interestsJSON: encode(profile.interests),
            creativeIntentsJSON: encode(profile.creativeIntents),
            preferredCaptureModeRaw: profile.preferredCaptureMode.rawValue,
            creativeRhythmRaw: profile.creativeRhythm.rawValue,
            onboardingCompleted: profile.onboardingCompleted,
            updatedAt: profile.updatedAt
        )
    }
}
