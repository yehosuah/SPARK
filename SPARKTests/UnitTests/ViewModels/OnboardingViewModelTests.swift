import Testing
@testable import SPARK

@MainActor
struct OnboardingViewModelTests {
    @Test
    func finishPersistsCompletedProfile() throws {
        let container = makeTestContainer()
        let viewModel = OnboardingViewModel(container: container)

        viewModel.state.step = .complete
        viewModel.state.selectedInterests = [.technology, .product, .finance]
        viewModel.state.selectedIntents = [.moreOriginalIdeas, .sharperInsight]
        viewModel.state.preferredMode = .voice
        viewModel.state.creativeRhythm = .dailySparks

        let profile = try viewModel.finish()
        let persisted = try container.services.onboardingService.currentProfile()

        #expect(profile.onboardingCompleted)
        #expect(persisted?.preferredCaptureMode == .voice)
        #expect(persisted?.creativeRhythm == .dailySparks)
    }
}
