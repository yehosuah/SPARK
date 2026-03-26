import Foundation
@testable import SPARK

@MainActor
final class MockResurfacingService: ResurfacingService {
    var home: ResurfacedItem?
    var library: [ResurfacedItem] = []

    func homeCandidate() throws -> ResurfacedItem? { home }
    func libraryCandidates(limit: Int) throws -> [ResurfacedItem] { Array(library.prefix(limit)) }
    func dismiss(_ item: ResurfacedItem) {
        library.removeAll { $0.id == item.id }
    }
}
