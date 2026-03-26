import SwiftData

@MainActor
final class PersistenceController {
    let modelContainer: ModelContainer

    init(inMemory: Bool = false) {
        do {
            self.modelContainer = try ModelContainerFactory.make(inMemory: inMemory)
        } catch {
            fatalError("Could not initialize model container: \(error)")
        }
    }

    var mainContext: ModelContext {
        modelContainer.mainContext
    }
}
