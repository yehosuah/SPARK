import Foundation
import SwiftData

@MainActor
protocol DraftRepository: AnyObject {
    func fetchAll() throws -> [Draft]
    func fetch(id: UUID) throws -> Draft?
    func save(_ draft: Draft) throws
    func delete(_ draftID: UUID) throws
}

@MainActor
final class SwiftDataDraftRepository: DraftRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [Draft] {
        let descriptor = FetchDescriptor<PersistentDraft>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map(DraftMapper.toDomain)
    }

    func fetch(id: UUID) throws -> Draft? {
        var descriptor = FetchDescriptor<PersistentDraft>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first.map(DraftMapper.toDomain)
    }

    func save(_ draft: Draft) throws {
        if let existing = try fetchPersistentDraft(id: draft.id) {
            DraftMapper.update(existing, with: draft)
        } else {
            modelContext.insert(DraftMapper.makePersistent(from: draft))
        }
        try modelContext.save()
    }

    func delete(_ draftID: UUID) throws {
        guard let draft = try fetchPersistentDraft(id: draftID) else { return }
        modelContext.delete(draft)
        try modelContext.save()
    }

    private func fetchPersistentDraft(id: UUID) throws -> PersistentDraft? {
        var descriptor = FetchDescriptor<PersistentDraft>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
