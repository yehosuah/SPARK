import Foundation

struct StimulusState: Identifiable, Codable, Equatable, Hashable {
    var stimulusID: UUID
    var isSaved: Bool
    var savedAt: Date?
    var isDismissed: Bool
    var lastViewedAt: Date?
    var responseCount: Int
    var buildCount: Int

    init(
        stimulusID: UUID,
        isSaved: Bool = false,
        savedAt: Date? = nil,
        isDismissed: Bool = false,
        lastViewedAt: Date? = nil,
        responseCount: Int = 0,
        buildCount: Int = 0
    ) {
        self.stimulusID = stimulusID
        self.isSaved = isSaved
        self.savedAt = savedAt
        self.isDismissed = isDismissed
        self.lastViewedAt = lastViewedAt
        self.responseCount = responseCount
        self.buildCount = buildCount
    }

    var id: UUID { stimulusID }
}

enum StimulusLinkRelation: String, Codable, CaseIterable, Hashable {
    case savedFrom
    case respondingTo
    case builtFrom
}

struct StimulusLink: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var stimulusID: UUID
    var relation: StimulusLinkRelation
    var snapshotTitle: String
    var snapshotFamilyRaw: String
    var snapshotSummary: String?

    init(
        id: UUID = UUID(),
        stimulusID: UUID,
        relation: StimulusLinkRelation,
        snapshotTitle: String,
        snapshotFamilyRaw: String,
        snapshotSummary: String? = nil
    ) {
        self.id = id
        self.stimulusID = stimulusID
        self.relation = relation
        self.snapshotTitle = snapshotTitle
        self.snapshotFamilyRaw = snapshotFamilyRaw
        self.snapshotSummary = snapshotSummary
    }

    var snapshotFamily: StimulusFamily? {
        StimulusFamily(storageValue: snapshotFamilyRaw)
    }
}

extension Stimulus {
    func makeLink(relation: StimulusLinkRelation) -> StimulusLink {
        StimulusLink(
            stimulusID: id,
            relation: relation,
            snapshotTitle: title,
            snapshotFamilyRaw: family.rawValue,
            snapshotSummary: summary
        )
    }
}
