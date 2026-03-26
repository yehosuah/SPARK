import Foundation
import SwiftData

@Model
final class PersistentIdeaSheet {
    @Attribute(.unique) var id: UUID
    var title: String?
    var body: String
    var inferredTitle: Bool
    var primaryStimulusID: UUID?
    var stimulusLinksJSON: String
    var attachmentsJSON: String
    var tagsJSON: String
    var contextMarker: String?
    var statusRaw: String
    var createdAt: Date
    var updatedAt: Date
    var lastOpenedAt: Date
    var isFavorite: Bool
    var revisionCount: Int

    init(
        id: UUID,
        title: String?,
        body: String,
        inferredTitle: Bool,
        primaryStimulusID: UUID?,
        stimulusLinksJSON: String,
        attachmentsJSON: String,
        tagsJSON: String,
        contextMarker: String?,
        statusRaw: String,
        createdAt: Date,
        updatedAt: Date,
        lastOpenedAt: Date,
        isFavorite: Bool,
        revisionCount: Int
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.inferredTitle = inferredTitle
        self.primaryStimulusID = primaryStimulusID
        self.stimulusLinksJSON = stimulusLinksJSON
        self.attachmentsJSON = attachmentsJSON
        self.tagsJSON = tagsJSON
        self.contextMarker = contextMarker
        self.statusRaw = statusRaw
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastOpenedAt = lastOpenedAt
        self.isFavorite = isFavorite
        self.revisionCount = revisionCount
    }
}
