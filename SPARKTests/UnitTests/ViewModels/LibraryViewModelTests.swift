import Testing
@testable import SPARK

@MainActor
struct LibraryViewModelTests {
    @Test
    func searchRefreshNarrowsIdeas() throws {
        let container = makeTestContainer()
        try container.services.ideaRepository.save(IdeaSheet(title: "Portfolio taste", body: "Markets and product."))
        try container.services.ideaRepository.save(IdeaSheet(title: "Design systems", body: "Interface notes."))

        let viewModel = LibraryViewModel(container: container)
        viewModel.load()
        viewModel.searchQuery = "portfolio"
        viewModel.refreshSearch()

        #expect(viewModel.filteredIdeas.count == 1)
        #expect(viewModel.filteredIdeas.first?.resolvedTitle == "Portfolio taste")
    }
}
