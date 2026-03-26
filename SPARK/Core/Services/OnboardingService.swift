import Foundation

protocol OnboardingService: AnyObject {
    func currentProfile() throws -> UserProfile?
    func save(profile: UserProfile) throws
}

@MainActor
final class DefaultOnboardingService: OnboardingService {
    private let userProfileRepository: any UserProfileRepository

    init(userProfileRepository: any UserProfileRepository) {
        self.userProfileRepository = userProfileRepository
    }

    func currentProfile() throws -> UserProfile? {
        try userProfileRepository.fetchCurrent()
    }

    func save(profile: UserProfile) throws {
        try userProfileRepository.save(profile)
    }
}
