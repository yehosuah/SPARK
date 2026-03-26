import Foundation
import Testing
@testable import SPARK

@MainActor
struct ResurfacingServiceTests {
    @Test
    func forgottenIdeaBecomesCandidate() throws {
        let suiteName = "spark.tests.resurfacing.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let persistence = PersistenceController(inMemory: true)
        let ideaRepository = SwiftDataIdeaRepository(modelContext: persistence.mainContext)
        let stimulusRepository = SwiftDataStimulusRepository(modelContext: persistence.mainContext)
        let resurfacingRepository = UserDefaultsResurfacingRepository(userDefaults: userDefaults)
        let service = DefaultResurfacingService(
            ideaRepository: ideaRepository,
            stimulusRepository: stimulusRepository,
            resurfacingRepository: resurfacingRepository
        )

        let oldDate = Calendar.current.date(byAdding: .day, value: -(Constants.forgottenIdeaDays + 2), to: .now) ?? .now
        let forgotten = IdeaSheet(
            title: "Forgotten",
            body: "Short idea",
            createdAt: oldDate,
            updatedAt: oldDate,
            lastOpenedAt: oldDate
        )
        try ideaRepository.save(forgotten)

        let candidate = try service.homeCandidate()

        #expect(candidate?.title == "Forgotten")
        #expect(candidate?.reason == "You may want to return to this.")
        userDefaults.removePersistentDomain(forName: suiteName)
    }
}
