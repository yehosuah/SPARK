import Foundation

enum DraftMapper {
    static func toDomain(_ persistent: PersistentDraft) -> Draft {
        Draft(
            id: persistent.id,
            mode: CaptureMode(rawValue: persistent.modeRaw) ?? .write,
            text: persistent.text,
            primaryStimulusID: persistent.primaryStimulusID,
            stimulusLinks: decode(persistent.stimulusLinksJSON, fallback: []),
            tags: decode(persistent.tagsJSON, fallback: []),
            attachments: decode(persistent.attachmentsJSON, fallback: []),
            createdAt: persistent.createdAt,
            updatedAt: persistent.updatedAt,
            wasPromoted: persistent.wasPromoted
        )
    }

    static func update(_ persistent: PersistentDraft, with draft: Draft) {
        persistent.modeRaw = draft.mode.rawValue
        persistent.text = draft.text
        persistent.primaryStimulusID = draft.primaryStimulusID
        persistent.stimulusLinksJSON = encode(draft.stimulusLinks)
        persistent.tagsJSON = encode(draft.tags)
        persistent.attachmentsJSON = encode(draft.attachments)
        persistent.createdAt = draft.createdAt
        persistent.updatedAt = draft.updatedAt
        persistent.wasPromoted = draft.wasPromoted
    }

    static func makePersistent(from draft: Draft) -> PersistentDraft {
        PersistentDraft(
            id: draft.id,
            modeRaw: draft.mode.rawValue,
            text: draft.text,
            primaryStimulusID: draft.primaryStimulusID,
            stimulusLinksJSON: encode(draft.stimulusLinks),
            tagsJSON: encode(draft.tags),
            attachmentsJSON: encode(draft.attachments),
            createdAt: draft.createdAt,
            updatedAt: draft.updatedAt,
            wasPromoted: draft.wasPromoted
        )
    }
}
