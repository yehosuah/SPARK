import Testing
@testable import SPARK

@MainActor
struct DraftRepositoryTests {
    @Test
    func deleteRemovesDraft() throws {
        let persistence = PersistenceController(inMemory: true)
        let repository = SwiftDataDraftRepository(modelContext: persistence.mainContext)
        let draft = Draft(mode: .write, text: "A fragment")

        try repository.save(draft)
        try repository.delete(draft.id)

        let drafts = try repository.fetchAll()
        #expect(drafts.isEmpty)
    }
}
