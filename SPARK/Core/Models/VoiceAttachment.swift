import Foundation

struct VoiceAttachment: Identifiable, Codable, Hashable {
    var id: UUID
    var filePath: String
    var duration: TimeInterval
    var transcription: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        filePath: String,
        duration: TimeInterval,
        transcription: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.filePath = filePath
        self.duration = duration
        self.transcription = transcription
        self.createdAt = createdAt
    }
}
