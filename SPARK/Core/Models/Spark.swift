import Foundation

struct StimulusMedia: Identifiable, Codable, Equatable, Hashable {
    enum Kind: String, Codable, CaseIterable, Hashable {
        case image
        case video
        case audio
        case webEmbed
        case pdf
    }

    enum Role: String, Codable, CaseIterable, Hashable {
        case hero
        case supporting
        case left
        case right
    }

    enum Storage: Equatable, Hashable {
        case remoteURL(String)
        case bundleAsset(String)
        case systemSymbol(String)
    }

    var id: UUID
    var kind: Kind
    var role: Role
    var storage: Storage
    var caption: String?
    var credit: String?
    var width: Int?
    var height: Int?

    init(
        id: UUID = UUID(),
        kind: Kind = .image,
        role: Role,
        storage: Storage,
        caption: String? = nil,
        credit: String? = nil,
        width: Int? = nil,
        height: Int? = nil
    ) {
        self.id = id
        self.kind = kind
        self.role = role
        self.storage = storage
        self.caption = caption
        self.credit = credit
        self.width = width
        self.height = height
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case kind
        case role
        case storageType
        case storageValue
        case caption
        case credit
        case width
        case height
    }

    private enum StorageType: String, Codable {
        case remoteURL
        case bundleAsset
        case systemSymbol
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        kind = try container.decode(Kind.self, forKey: .kind)
        role = try container.decode(Role.self, forKey: .role)
        let storageType = try container.decode(StorageType.self, forKey: .storageType)
        let storageValue = try container.decode(String.self, forKey: .storageValue)
        switch storageType {
        case .remoteURL:
            storage = .remoteURL(storageValue)
        case .bundleAsset:
            storage = .bundleAsset(storageValue)
        case .systemSymbol:
            storage = .systemSymbol(storageValue)
        }
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        credit = try container.decodeIfPresent(String.self, forKey: .credit)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encode(role, forKey: .role)
        switch storage {
        case .remoteURL(let value):
            try container.encode(StorageType.remoteURL, forKey: .storageType)
            try container.encode(value, forKey: .storageValue)
        case .bundleAsset(let value):
            try container.encode(StorageType.bundleAsset, forKey: .storageType)
            try container.encode(value, forKey: .storageValue)
        case .systemSymbol(let value):
            try container.encode(StorageType.systemSymbol, forKey: .storageType)
            try container.encode(value, forKey: .storageValue)
        }
        try container.encodeIfPresent(caption, forKey: .caption)
        try container.encodeIfPresent(credit, forKey: .credit)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
    }
}

struct ArtifactStimulusPayload: Codable, Equatable, Hashable {
    var artifactKind: String
    var observedObject: String
    var focusPoints: [String]
    var borrowableMove: String
    var artifactMediaNotes: String?
}

struct CaseStimulusPayload: Codable, Equatable, Hashable {
    var caseSubject: String
    var situation: String
    var move: String
    var outcome: String
    var lesson: String
    var evidenceNote: String?
}

struct ContrastSide: Codable, Equatable, Hashable {
    var label: String
    var summary: String
    var mediaID: UUID?
}

struct ContrastStimulusPayload: Codable, Equatable, Hashable {
    var leftSide: ContrastSide
    var rightSide: ContrastSide
    var comparisonAxis: String
    var tension: String
    var editorialTake: String
}

struct PatternStimulusPayload: Codable, Equatable, Hashable {
    var patternName: String
    var mechanism: String
    var conditions: String
    var effect: String
    var whereItApplies: String
    var misuseWarning: String?
}

struct CollisionStimulusPayload: Codable, Equatable, Hashable {
    var worldA: String
    var worldB: String
    var collisionPremise: String
    var synthesisDirection: String
    var buildAngle: String
}

enum StimulusPayload: Equatable, Hashable {
    case artifact(ArtifactStimulusPayload)
    case caseStudy(CaseStimulusPayload)
    case contrast(ContrastStimulusPayload)
    case pattern(PatternStimulusPayload)
    case collision(CollisionStimulusPayload)
}

extension StimulusPayload: Codable {
    private enum CodingKeys: String, CodingKey {
        case family
        case artifact
        case caseStudy
        case contrast
        case pattern
        case collision
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let family = try container.decode(StimulusFamily.self, forKey: .family)
        switch family {
        case .artifact:
            self = .artifact(try container.decode(ArtifactStimulusPayload.self, forKey: .artifact))
        case .caseStudy:
            self = .caseStudy(try container.decode(CaseStimulusPayload.self, forKey: .caseStudy))
        case .contrast:
            self = .contrast(try container.decode(ContrastStimulusPayload.self, forKey: .contrast))
        case .pattern:
            self = .pattern(try container.decode(PatternStimulusPayload.self, forKey: .pattern))
        case .collision:
            self = .collision(try container.decode(CollisionStimulusPayload.self, forKey: .collision))
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .artifact(let payload):
            try container.encode(StimulusFamily.artifact, forKey: .family)
            try container.encode(payload, forKey: .artifact)
        case .caseStudy(let payload):
            try container.encode(StimulusFamily.caseStudy, forKey: .family)
            try container.encode(payload, forKey: .caseStudy)
        case .contrast(let payload):
            try container.encode(StimulusFamily.contrast, forKey: .family)
            try container.encode(payload, forKey: .contrast)
        case .pattern(let payload):
            try container.encode(StimulusFamily.pattern, forKey: .family)
            try container.encode(payload, forKey: .pattern)
        case .collision(let payload):
            try container.encode(StimulusFamily.collision, forKey: .family)
            try container.encode(payload, forKey: .collision)
        }
    }
}

struct Stimulus: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var externalID: String?
    var seedKey: String?
    var family: StimulusFamily
    var eyebrow: String?
    var title: String
    var summary: String
    var detailBody: String?
    var responseCue: String?
    var layoutEmphasis: StimulusLayoutEmphasis
    var heroMediaID: UUID?
    var media: [StimulusMedia]
    var taxonomy: StimulusTaxonomy
    var provenance: StimulusProvenance
    var isFeatured: Bool
    var editorialPriority: Int
    var collectionKey: String?
    var availabilityWindow: StimulusAvailabilityWindow?
    var publishedAt: Date
    var updatedAt: Date
    var payload: StimulusPayload

    init(
        id: UUID = UUID(),
        externalID: String? = nil,
        seedKey: String? = nil,
        family: StimulusFamily,
        eyebrow: String? = nil,
        title: String,
        summary: String,
        detailBody: String? = nil,
        responseCue: String? = nil,
        layoutEmphasis: StimulusLayoutEmphasis = .editorialHero,
        heroMediaID: UUID? = nil,
        media: [StimulusMedia] = [],
        taxonomy: StimulusTaxonomy = StimulusTaxonomy(),
        provenance: StimulusProvenance,
        isFeatured: Bool = false,
        editorialPriority: Int = 0,
        collectionKey: String? = nil,
        availabilityWindow: StimulusAvailabilityWindow? = nil,
        publishedAt: Date = .now,
        updatedAt: Date = .now,
        payload: StimulusPayload
    ) {
        self.id = id
        self.externalID = externalID
        self.seedKey = seedKey
        self.family = family
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.detailBody = detailBody
        self.responseCue = responseCue
        self.layoutEmphasis = layoutEmphasis
        self.heroMediaID = heroMediaID
        self.media = media
        self.taxonomy = taxonomy
        self.provenance = provenance
        self.isFeatured = isFeatured
        self.editorialPriority = editorialPriority
        self.collectionKey = collectionKey
        self.availabilityWindow = availabilityWindow
        self.publishedAt = publishedAt
        self.updatedAt = updatedAt
        self.payload = payload
    }

    var heroMedia: StimulusMedia? {
        if let heroMediaID {
            return media.first(where: { $0.id == heroMediaID })
        }
        return media.first(where: { $0.role == .hero })
    }

    var familyTitle: String {
        family.title
    }

    var whyChosen: String? {
        provenance.editorialMetadata?.whyChosen
    }

    var primaryDomainTitle: String? {
        taxonomy.domains.first?.title
    }

    var searchableText: String {
        let payloadText: [String] = {
            switch payload {
            case .artifact(let payload):
                return [payload.observedObject, payload.borrowableMove] + payload.focusPoints
            case .caseStudy(let payload):
                return [payload.caseSubject, payload.situation, payload.move, payload.outcome, payload.lesson]
            case .contrast(let payload):
                return [
                    payload.leftSide.label,
                    payload.leftSide.summary,
                    payload.rightSide.label,
                    payload.rightSide.summary,
                    payload.comparisonAxis,
                    payload.tension,
                    payload.editorialTake
                ]
            case .pattern(let payload):
                return [payload.patternName, payload.mechanism, payload.conditions, payload.effect, payload.whereItApplies]
            case .collision(let payload):
                return [payload.worldA, payload.worldB, payload.collisionPremise, payload.synthesisDirection, payload.buildAngle]
            }
        }()

        let sourceText = provenance.sourceRefs.flatMap { [$0.title, $0.creator, $0.publication, $0.citationNote] }
        let taxonomyText = taxonomy.keywords + taxonomy.editorialTags + taxonomy.domains.map(\.title) + taxonomy.creativeGoalHints.map(\.title)
        return ([eyebrow, title, summary, detailBody, responseCue] + payloadText + sourceText + taxonomyText)
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

struct StimulusRecord: Identifiable, Equatable, Hashable {
    var stimulus: Stimulus
    var state: StimulusState

    var id: UUID { stimulus.id }
    var family: StimulusFamily { stimulus.family }
    var title: String { stimulus.title }
    var summary: String { stimulus.summary }
    var detailBody: String? { stimulus.detailBody }
    var responseCue: String? { stimulus.responseCue }
    var media: [StimulusMedia] { stimulus.media }
    var heroMedia: StimulusMedia? { stimulus.heroMedia }
    var isFeatured: Bool { stimulus.isFeatured }
    var editorialPriority: Int { stimulus.editorialPriority }
    var taxonomy: StimulusTaxonomy { stimulus.taxonomy }
    var provenance: StimulusProvenance { stimulus.provenance }
    var payload: StimulusPayload { stimulus.payload }
    var isSaved: Bool { state.isSaved }
    var isDismissed: Bool { state.isDismissed }
    var responseCount: Int { state.responseCount }
    var buildCount: Int { state.buildCount }
}
