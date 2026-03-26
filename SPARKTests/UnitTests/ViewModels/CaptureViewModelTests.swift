import Testing
@testable import SPARK

@MainActor
struct CaptureViewModelTests {
    @Test
    func saveAsIdeaPromotesDraftIntoRepository() async throws {
        let container = makeTestContainer()
        let viewModel = CaptureViewModel(container: container, initialMode: .write)

        await viewModel.loadIfNeeded()
        viewModel.updateText("A strong idea worth keeping.")
        let ideaID = try viewModel.saveAsIdea()

        let savedIdea = try container.services.ideaRepository.fetch(id: ideaID)
        #expect(savedIdea?.body == "A strong idea worth keeping.")
    }
}
