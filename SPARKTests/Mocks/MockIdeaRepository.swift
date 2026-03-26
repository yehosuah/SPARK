import Foundation
@testable import SPARK

@MainActor
final class MockIdeaRepository: IdeaRepository {
    var ideas: [IdeaSheet] = []

    func fetchAll() throws -> [IdeaSheet] { ideas }
    func fetch(id: UUID) throws -> IdeaSheet? { ideas.first { $0.id == id } }
    func save(_ idea: IdeaSheet) throws {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
        } else {
            ideas.append(idea)
        }
    }
    func markOpened(_ ideaID: UUID) throws {}
    func relatedIdeas(for idea: IdeaSheet, limit: Int) throws -> [IdeaSheet] {
        Array(ideas.filter { $0.id != idea.id }.prefix(limit))
    }
}
