import Testing
@testable import SPARK

@MainActor
struct IdeaDetailViewModelTests {
    @Test
    func runningAndAcceptingSuggestionAppendsContent() async throws {
        let container = makeTestContainer()
        let seedIdea = IdeaSheet(title: "Seed", body: "A rough note.")
        try container.services.ideaRepository.save(seedIdea)

        let viewModel = IdeaDetailViewModel(container: container, ideaID: seedIdea.id)
        viewModel.load()
        await viewModel.run(action: .reframe)
        viewModel.acceptSuggestion()

        #expect(viewModel.idea?.body.contains("Working move — Reframe") == true)
        #expect(viewModel.idea?.body.contains("Reframe this around the shift in perception") == true)
    }
}
