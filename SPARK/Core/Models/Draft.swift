import Foundation

struct Draft: Identifiable, Codable, Equatable {
    var id: UUID
    var mode: CaptureMode
    var text: String
    var primaryStimulusID: UUID?
    var stimulusLinks: [StimulusLink]
    var tags: [Tag]
    var attachments: [Attachment]
    var createdAt: Date
    var updatedAt: Date
    var wasPromoted: Bool

    init(
        id: UUID = UUID(),
        mode: CaptureMode,
        text: String = "",
        primaryStimulusID: UUID? = nil,
        stimulusLinks: [StimulusLink] = [],
        tags: [Tag] = [],
        attachments: [Attachment] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now,
        wasPromoted: Bool = false
    ) {
        self.id = id
        self.mode = mode
        self.text = text
        self.primaryStimulusID = primaryStimulusID
        self.stimulusLinks = stimulusLinks
        self.tags = tags
        self.attachments = attachments
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.wasPromoted = wasPromoted
    }

    var titleCandidate: String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstLine = trimmed.components(separatedBy: .newlines).first, !firstLine.isEmpty else {
            return "Untitled draft"
        }
        return firstLine
    }

    var sourceStimulusLink: StimulusLink? {
        if let primaryStimulusID {
            return stimulusLinks.first(where: { $0.stimulusID == primaryStimulusID })
        }
        return stimulusLinks.first
    }
}
