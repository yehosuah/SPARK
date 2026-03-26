import Foundation
import SwiftData

@MainActor
protocol IdeaRepository: AnyObject {
    func fetchAll() throws -> [IdeaSheet]
    func fetch(id: UUID) throws -> IdeaSheet?
    func save(_ idea: IdeaSheet) throws
    func markOpened(_ ideaID: UUID) throws
    func relatedIdeas(for idea: IdeaSheet, limit: Int) throws -> [IdeaSheet]
}

@MainActor
final class SwiftDataIdeaRepository: IdeaRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [IdeaSheet] {
        let descriptor = FetchDescriptor<PersistentIdeaSheet>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map(IdeaSheetMapper.toDomain)
    }

    func fetch(id: UUID) throws -> IdeaSheet? {
        var descriptor = FetchDescriptor<PersistentIdeaSheet>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first.map(IdeaSheetMapper.toDomain)
    }

    func save(_ idea: IdeaSheet) throws {
        if let existing = try fetchPersistentIdea(id: idea.id) {
            IdeaSheetMapper.update(existing, with: idea)
        } else {
            modelContext.insert(IdeaSheetMapper.makePersistent(from: idea))
        }
        try persistTags(idea.tags)
        try modelContext.save()
    }

    func markOpened(_ ideaID: UUID) throws {
        guard let idea = try fetchPersistentIdea(id: ideaID) else { return }
        idea.lastOpenedAt = .now
        try modelContext.save()
    }

    func relatedIdeas(for idea: IdeaSheet, limit: Int = 3) throws -> [IdeaSheet] {
        let ideas = try fetchAll().filter { $0.id != idea.id }
        let sourceTagNames = Set(idea.tags.map { $0.name.lowercased() })
        return ideas
            .map { candidate in
                let overlap = sourceTagNames.intersection(candidate.tags.map { $0.name.lowercased() }).count
                let linkedOverlap = Set(idea.stimulusLinks.map(\.stimulusID)).intersection(candidate.stimulusLinks.map(\.stimulusID)).count
                return (candidate, overlap + linkedOverlap)
            }
            .filter { $0.1 > 0 || $0.0.primaryStimulusID == idea.primaryStimulusID }
            .sorted { lhs, rhs in
                if lhs.1 == rhs.1 {
                    return lhs.0.updatedAt > rhs.0.updatedAt
                }
                return lhs.1 > rhs.1
            }
            .prefix(limit)
            .map(\.0)
    }

    private func fetchPersistentIdea(id: UUID) throws -> PersistentIdeaSheet? {
        var descriptor = FetchDescriptor<PersistentIdeaSheet>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func persistTags(_ tags: [Tag]) throws {
        let existing = try modelContext.fetch(FetchDescriptor<PersistentTag>())
        let existingNames = Set(existing.map(\.name))
        for tag in tags where !existingNames.contains(tag.name.lowercased()) {
            modelContext.insert(PersistentTag(name: tag.name.lowercased(), createdAt: tag.createdAt))
        }
    }
}
