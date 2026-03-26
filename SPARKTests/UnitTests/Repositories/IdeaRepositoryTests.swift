import Testing
@testable import SPARK

@MainActor
struct IdeaRepositoryTests {
    @Test
    func relatedIdeasPreferTagOverlap() throws {
        let persistence = PersistenceController(inMemory: true)
        let repository = SwiftDataIdeaRepository(modelContext: persistence.mainContext)

        let base = IdeaSheet(title: "Base", body: "Body", tags: [Tag(name: "ai"), Tag(name: "strategy")])
        let related = IdeaSheet(title: "Related", body: "Body", tags: [Tag(name: "ai")])
        let unrelated = IdeaSheet(title: "Unrelated", body: "Body", tags: [Tag(name: "culture")])

        try repository.save(base)
        try repository.save(related)
        try repository.save(unrelated)

        let matches = try repository.relatedIdeas(for: base, limit: 2)

        #expect(matches.first?.title == "Related")
    }
}
