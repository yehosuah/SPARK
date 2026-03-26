import Foundation

struct ResurfacedItem: Identifiable, Equatable {
    enum Kind: Equatable {
        case idea(UUID)
        case stimulus(UUID)
    }

    var id: UUID
    var kind: Kind
    var title: String
    var preview: String
    var reason: String
    var score: Double

    init(
        id: UUID = UUID(),
        kind: Kind,
        title: String,
        preview: String,
        reason: String,
        score: Double
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.preview = preview
        self.reason = reason
        self.score = score
    }
}
