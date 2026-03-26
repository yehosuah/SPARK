import Foundation

enum IdeaStatus: String, Codable, CaseIterable, Hashable {
    case active
    case paused
    case complete
}

struct IdeaSheet: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String?
    var body: String
    var inferredTitle: Bool
    var primaryStimulusID: UUID?
    var stimulusLinks: [StimulusLink]
    var attachments: [Attachment]
    var tags: [Tag]
    var contextMarker: String?
    var status: IdeaStatus
    var createdAt: Date
    var updatedAt: Date
    var lastOpenedAt: Date
    var isFavorite: Bool
    var revisionCount: Int

    init(
        id: UUID = UUID(),
        title: String? = nil,
        body: String = "",
        inferredTitle: Bool = true,
        primaryStimulusID: UUID? = nil,
        stimulusLinks: [StimulusLink] = [],
        attachments: [Attachment] = [],
        tags: [Tag] = [],
        contextMarker: String? = nil,
        status: IdeaStatus = .active,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        lastOpenedAt: Date = .now,
        isFavorite: Bool = false,
        revisionCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.inferredTitle = inferredTitle
        self.primaryStimulusID = primaryStimulusID
        self.stimulusLinks = stimulusLinks
        self.attachments = attachments
        self.tags = tags
        self.contextMarker = contextMarker
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastOpenedAt = lastOpenedAt
        self.isFavorite = isFavorite
        self.revisionCount = revisionCount
    }

    var resolvedTitle: String {
        if let title, !title.isBlank {
            return title
        }

        let firstLine = body.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return firstLine?.isEmpty == false ? firstLine! : "Untitled Idea"
    }

    var previewText: String {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "A fragment is enough." : trimmed
    }

    var isUnfinished: Bool {
        status != .complete && body.count < Constants.unfinishedIdeaThreshold
    }

    var sourceStimulusLink: StimulusLink? {
        if let primaryStimulusID {
            return stimulusLinks.first(where: { $0.stimulusID == primaryStimulusID })
        }
        return stimulusLinks.first
    }
}
