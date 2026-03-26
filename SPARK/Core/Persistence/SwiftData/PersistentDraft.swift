import Foundation
import SwiftData

@Model
final class PersistentDraft {
    @Attribute(.unique) var id: UUID
    var modeRaw: String
    var text: String
    var primaryStimulusID: UUID?
    var stimulusLinksJSON: String
    var tagsJSON: String
    var attachmentsJSON: String
    var createdAt: Date
    var updatedAt: Date
    var wasPromoted: Bool

    init(
        id: UUID,
        modeRaw: String,
        text: String,
        primaryStimulusID: UUID?,
        stimulusLinksJSON: String,
        tagsJSON: String,
        attachmentsJSON: String,
        createdAt: Date,
        updatedAt: Date,
        wasPromoted: Bool
    ) {
        self.id = id
        self.modeRaw = modeRaw
        self.text = text
        self.primaryStimulusID = primaryStimulusID
        self.stimulusLinksJSON = stimulusLinksJSON
        self.tagsJSON = tagsJSON
        self.attachmentsJSON = attachmentsJSON
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.wasPromoted = wasPromoted
    }
}
