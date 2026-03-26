import Testing
@testable import SPARK

@MainActor
struct SearchServiceTests {
    @Test
    func searchFindsIdeasAndDrafts() throws {
        let container = makeTestContainer()
        try container.services.ideaRepository.save(IdeaSheet(title: "Market thesis", body: "A note about allocation."))
        try container.services.draftRepository.save(Draft(mode: .write, text: "Allocation draft"))

        let results = try container.services.searchService.search(query: "allocation")

        #expect(results.ideas.count == 1)
        #expect(results.drafts.count == 1)
    }
}
