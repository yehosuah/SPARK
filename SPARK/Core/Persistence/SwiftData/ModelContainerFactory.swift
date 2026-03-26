import SwiftData

enum ModelContainerFactory {
    static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            PersistentStimulus.self,
            PersistentStimulusState.self,
            PersistentIdeaSheet.self,
            PersistentDraft.self,
            PersistentUserProfile.self,
            PersistentTag.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
