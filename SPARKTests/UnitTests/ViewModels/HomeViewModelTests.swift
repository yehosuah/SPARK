import Testing
@testable import SPARK

@MainActor
struct HomeViewModelTests {
    @Test
    func loadProvidesFeaturedStimulusAndThreeHomeStimuli() async throws {
        let container = makeTestContainer()
        try container.services.onboardingService.save(
            profile: UserProfile(
                interests: [.product, .technology, .design],
                creativeIntents: [.moreOriginalIdeas],
                preferredCaptureMode: .write,
                creativeRhythm: .both,
                onboardingCompleted: true
            )
        )

        let viewModel = HomeViewModel(container: container)
        await viewModel.load()

        #expect(viewModel.featuredStimulus != nil)
        #expect(viewModel.todayStimuli.count == Constants.homeSparkCount)
    }
}
