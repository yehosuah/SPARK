import Foundation

struct SketchAttachment: Identifiable, Codable, Hashable {
    var id: UUID
    var filePath: String
    var note: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        filePath: String,
        note: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.filePath = filePath
        self.note = note
        self.createdAt = createdAt
    }
}
