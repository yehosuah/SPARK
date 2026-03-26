import Foundation
import SwiftData

@MainActor
protocol UserProfileRepository: AnyObject {
    func fetchCurrent() throws -> UserProfile?
    func save(_ profile: UserProfile) throws
}

@MainActor
final class SwiftDataUserProfileRepository: UserProfileRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchCurrent() throws -> UserProfile? {
        var descriptor = FetchDescriptor<PersistentUserProfile>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first.map(UserProfileMapper.toDomain)
    }

    func save(_ profile: UserProfile) throws {
        if let existing = try fetchPersistentProfile() {
            UserProfileMapper.update(existing, with: profile)
        } else {
            modelContext.insert(UserProfileMapper.makePersistent(from: profile))
        }
        try modelContext.save()
    }

    private func fetchPersistentProfile() throws -> PersistentUserProfile? {
        var descriptor = FetchDescriptor<PersistentUserProfile>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
