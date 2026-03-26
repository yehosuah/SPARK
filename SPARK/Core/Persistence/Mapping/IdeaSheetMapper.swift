import Foundation

enum IdeaSheetMapper {
    static func toDomain(_ persistent: PersistentIdeaSheet) -> IdeaSheet {
        IdeaSheet(
            id: persistent.id,
            title: persistent.title,
            body: persistent.body,
            inferredTitle: persistent.inferredTitle,
            primaryStimulusID: persistent.primaryStimulusID,
            stimulusLinks: decode(persistent.stimulusLinksJSON, fallback: []),
            attachments: decode(persistent.attachmentsJSON, fallback: []),
            tags: decode(persistent.tagsJSON, fallback: []),
            contextMarker: persistent.contextMarker,
            status: IdeaStatus(rawValue: persistent.statusRaw) ?? .active,
            createdAt: persistent.createdAt,
            updatedAt: persistent.updatedAt,
            lastOpenedAt: persistent.lastOpenedAt,
            isFavorite: persistent.isFavorite,
            revisionCount: persistent.revisionCount
        )
    }

    static func update(_ persistent: PersistentIdeaSheet, with idea: IdeaSheet) {
        persistent.title = idea.title
        persistent.body = idea.body
        persistent.inferredTitle = idea.inferredTitle
        persistent.primaryStimulusID = idea.primaryStimulusID
        persistent.stimulusLinksJSON = encode(idea.stimulusLinks)
        persistent.attachmentsJSON = encode(idea.attachments)
        persistent.tagsJSON = encode(idea.tags)
        persistent.contextMarker = idea.contextMarker
        persistent.statusRaw = idea.status.rawValue
        persistent.createdAt = idea.createdAt
        persistent.updatedAt = idea.updatedAt
        persistent.lastOpenedAt = idea.lastOpenedAt
        persistent.isFavorite = idea.isFavorite
        persistent.revisionCount = idea.revisionCount
    }

    static func makePersistent(from idea: IdeaSheet) -> PersistentIdeaSheet {
        PersistentIdeaSheet(
            id: idea.id,
            title: idea.title,
            body: idea.body,
            inferredTitle: idea.inferredTitle,
            primaryStimulusID: idea.primaryStimulusID,
            stimulusLinksJSON: encode(idea.stimulusLinks),
            attachmentsJSON: encode(idea.attachments),
            tagsJSON: encode(idea.tags),
            contextMarker: idea.contextMarker,
            statusRaw: idea.status.rawValue,
            createdAt: idea.createdAt,
            updatedAt: idea.updatedAt,
            lastOpenedAt: idea.lastOpenedAt,
            isFavorite: idea.isFavorite,
            revisionCount: idea.revisionCount
        )
    }
}
