import Testing
@testable import SPARK

@MainActor
struct StimulusRepositoryTests {
    @Test
    func upsertAndFetchSavedStimulus() throws {
        let persistence = PersistenceController(inMemory: true)
        let repository = SwiftDataStimulusRepository(modelContext: persistence.mainContext)
        let stimulus = Stimulus(
            family: .artifact,
            title: "Saved stimulus",
            summary: "A saved summary",
            provenance: StimulusProvenance(origin: .seededLocal),
            payload: .artifact(
                ArtifactStimulusPayload(
                    artifactKind: "Reference",
                    observedObject: "Saved object",
                    focusPoints: [],
                    borrowableMove: "Borrow the calm move",
                    artifactMediaNotes: nil
                )
            )
        )

        try repository.upsert(stimulus)
        try repository.setSaved(true, for: stimulus.id)

        let saved = try repository.fetchSaved()
        #expect(saved.count == 1)
        #expect(saved.first?.title == "Saved stimulus")
        #expect(saved.first?.isSaved == true)
    }
}
