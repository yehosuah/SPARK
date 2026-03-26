import Foundation

enum StimulusLayoutEmphasis: String, Codable, CaseIterable, Hashable {
    case editorialHero
    case visualHero
    case splitComparison
    case mechanism
    case synthesis
}

enum StimulusOrigin: String, Codable, CaseIterable, Hashable {
    case apiIngested
    case aiTransformed
    case editorialCurated
    case seededLocal
}

struct StimulusAvailabilityWindow: Codable, Equatable, Hashable {
    var start: Date?
    var end: Date?

    init(start: Date? = nil, end: Date? = nil) {
        self.start = start
        self.end = end
    }
}

struct StimulusTaxonomy: Codable, Equatable, Hashable {
    var domains: [InterestDomain]
    var creativeGoalHints: [CreativeIntent]
    var keywords: [String]
    var editorialTags: [String]

    init(
        domains: [InterestDomain] = [],
        creativeGoalHints: [CreativeIntent] = [],
        keywords: [String] = [],
        editorialTags: [String] = []
    ) {
        self.domains = domains
        self.creativeGoalHints = creativeGoalHints
        self.keywords = keywords
        self.editorialTags = editorialTags
    }
}

struct StimulusSourceRef: Identifiable, Codable, Equatable, Hashable {
    enum SourceType: String, Codable, CaseIterable, Hashable {
        case article
        case product
        case image
        case book
        case note
        case internalSeed
        case editorial
        case unknown
    }

    var id: UUID
    var sourceType: SourceType
    var title: String
    var creator: String?
    var publication: String?
    var url: String?
    var assetKey: String?
    var citationNote: String?

    init(
        id: UUID = UUID(),
        sourceType: SourceType,
        title: String,
        creator: String? = nil,
        publication: String? = nil,
        url: String? = nil,
        assetKey: String? = nil,
        citationNote: String? = nil
    ) {
        self.id = id
        self.sourceType = sourceType
        self.title = title
        self.creator = creator
        self.publication = publication
        self.url = url
        self.assetKey = assetKey
        self.citationNote = citationNote
    }
}

struct StimulusTransformationRecord: Codable, Equatable, Hashable {
    enum Kind: String, Codable, CaseIterable, Hashable {
        case reinterpretation
        case extraction
        case comparativeReframe
        case editorialRewrite
    }

    var kind: Kind
    var inputSourceRefIDs: [UUID]
    var modelName: String?
    var provider: String?
    var reviewedByEditor: Bool

    init(
        kind: Kind,
        inputSourceRefIDs: [UUID] = [],
        modelName: String? = nil,
        provider: String? = nil,
        reviewedByEditor: Bool = false
    ) {
        self.kind = kind
        self.inputSourceRefIDs = inputSourceRefIDs
        self.modelName = modelName
        self.provider = provider
        self.reviewedByEditor = reviewedByEditor
    }
}

struct StimulusEditorialMetadata: Codable, Equatable, Hashable {
    var curatedTitle: String?
    var emphasisNote: String?
    var whyChosen: String?
    var feedPriority: Int

    init(
        curatedTitle: String? = nil,
        emphasisNote: String? = nil,
        whyChosen: String? = nil,
        feedPriority: Int = 0
    ) {
        self.curatedTitle = curatedTitle
        self.emphasisNote = emphasisNote
        self.whyChosen = whyChosen
        self.feedPriority = feedPriority
    }
}

struct StimulusProvenance: Codable, Equatable, Hashable {
    var origin: StimulusOrigin
    var sourceRefs: [StimulusSourceRef]
    var transformationRecord: StimulusTransformationRecord?
    var editorialMetadata: StimulusEditorialMetadata?

    init(
        origin: StimulusOrigin,
        sourceRefs: [StimulusSourceRef] = [],
        transformationRecord: StimulusTransformationRecord? = nil,
        editorialMetadata: StimulusEditorialMetadata? = nil
    ) {
        self.origin = origin
        self.sourceRefs = sourceRefs
        self.transformationRecord = transformationRecord
        self.editorialMetadata = editorialMetadata
    }
}
