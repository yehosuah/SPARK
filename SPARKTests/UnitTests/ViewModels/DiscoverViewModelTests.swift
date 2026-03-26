import Testing
@testable import SPARK

@MainActor
struct DiscoverViewModelTests {
    @Test
    func filterByStimulusFamilyNarrowsVisibleResults() async {
        let container = makeTestContainer()
        let viewModel = DiscoverViewModel(container: container)

        await viewModel.load()
        viewModel.toggleFamily(.contrast)

        #expect(viewModel.filteredStimuli.allSatisfy { $0.family == .contrast })
    }
}
