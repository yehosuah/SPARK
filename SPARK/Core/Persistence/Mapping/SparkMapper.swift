import Foundation

enum StimulusMapper {
    static func toDomain(_ persistent: PersistentStimulus) -> Stimulus {
        Stimulus(
            id: persistent.id,
            externalID: persistent.externalID,
            seedKey: persistent.seedKey,
            family: StimulusFamily(storageValue: persistent.familyRaw) ?? .artifact,
            eyebrow: persistent.eyebrow,
            title: persistent.title,
            summary: persistent.summary,
            detailBody: persistent.detailBody,
            responseCue: persistent.responseCue,
            layoutEmphasis: StimulusLayoutEmphasis(rawValue: persistent.layoutEmphasisRaw) ?? .editorialHero,
            heroMediaID: persistent.heroMediaID,
            media: decode(persistent.mediaJSON, fallback: []),
            taxonomy: decode(persistent.taxonomyJSON, fallback: StimulusTaxonomy()),
            provenance: decode(
                persistent.provenanceJSON,
                fallback: StimulusProvenance(origin: .seededLocal)
            ),
            isFeatured: persistent.isFeatured,
            editorialPriority: persistent.editorialPriority,
            collectionKey: persistent.collectionKey,
            availabilityWindow: decode(persistent.availabilityWindowJSON, fallback: nil),
            publishedAt: persistent.publishedAt,
            updatedAt: persistent.updatedAt,
            payload: decode(
                persistent.payloadJSON,
                fallback: StimulusPayload.artifact(
                    ArtifactStimulusPayload(
                        artifactKind: "Reference",
                        observedObject: persistent.title,
                        focusPoints: [],
                        borrowableMove: persistent.summary,
                        artifactMediaNotes: nil
                    )
                )
            )
        )
    }

    static func toState(_ persistent: PersistentStimulusState) -> StimulusState {
        StimulusState(
            stimulusID: persistent.stimulusID,
            isSaved: persistent.isSaved,
            savedAt: persistent.savedAt,
            isDismissed: persistent.isDismissed,
            lastViewedAt: persistent.lastViewedAt,
            responseCount: persistent.responseCount,
            buildCount: persistent.buildCount
        )
    }

    static func update(_ persistent: PersistentStimulus, with stimulus: Stimulus) {
        persistent.externalID = stimulus.externalID
        persistent.seedKey = stimulus.seedKey
        persistent.familyRaw = stimulus.family.rawValue
        persistent.eyebrow = stimulus.eyebrow
        persistent.title = stimulus.title
        persistent.summary = stimulus.summary
        persistent.detailBody = stimulus.detailBody
        persistent.responseCue = stimulus.responseCue
        persistent.layoutEmphasisRaw = stimulus.layoutEmphasis.rawValue
        persistent.heroMediaID = stimulus.heroMediaID
        persistent.mediaJSON = encode(stimulus.media)
        persistent.taxonomyJSON = encode(stimulus.taxonomy)
        persistent.provenanceJSON = encode(stimulus.provenance)
        persistent.payloadJSON = encode(stimulus.payload)
        persistent.isFeatured = stimulus.isFeatured
        persistent.editorialPriority = stimulus.editorialPriority
        persistent.collectionKey = stimulus.collectionKey
        persistent.availabilityWindowJSON = encode(stimulus.availabilityWindow)
        persistent.primaryDomainRaw = stimulus.taxonomy.domains.first?.rawValue
        persistent.publishedAt = stimulus.publishedAt
        persistent.updatedAt = stimulus.updatedAt
    }

    static func update(_ persistent: PersistentStimulusState, with state: StimulusState) {
        persistent.isSaved = state.isSaved
        persistent.savedAt = state.savedAt
        persistent.isDismissed = state.isDismissed
        persistent.lastViewedAt = state.lastViewedAt
        persistent.responseCount = state.responseCount
        persistent.buildCount = state.buildCount
    }

    static func makePersistent(from stimulus: Stimulus) -> PersistentStimulus {
        PersistentStimulus(
            id: stimulus.id,
            externalID: stimulus.externalID,
            seedKey: stimulus.seedKey,
            familyRaw: stimulus.family.rawValue,
            eyebrow: stimulus.eyebrow,
            title: stimulus.title,
            summary: stimulus.summary,
            detailBody: stimulus.detailBody,
            responseCue: stimulus.responseCue,
            layoutEmphasisRaw: stimulus.layoutEmphasis.rawValue,
            heroMediaID: stimulus.heroMediaID,
            mediaJSON: encode(stimulus.media),
            taxonomyJSON: encode(stimulus.taxonomy),
            provenanceJSON: encode(stimulus.provenance),
            payloadJSON: encode(stimulus.payload),
            isFeatured: stimulus.isFeatured,
            editorialPriority: stimulus.editorialPriority,
            collectionKey: stimulus.collectionKey,
            availabilityWindowJSON: encode(stimulus.availabilityWindow),
            primaryDomainRaw: stimulus.taxonomy.domains.first?.rawValue,
            publishedAt: stimulus.publishedAt,
            updatedAt: stimulus.updatedAt
        )
    }

    static func makePersistentState(from state: StimulusState) -> PersistentStimulusState {
        PersistentStimulusState(
            stimulusID: state.stimulusID,
            isSaved: state.isSaved,
            savedAt: state.savedAt,
            isDismissed: state.isDismissed,
            lastViewedAt: state.lastViewedAt,
            responseCount: state.responseCount,
            buildCount: state.buildCount
        )
    }
}

func encode<T: Encodable>(_ value: T) -> String {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    guard let data = try? encoder.encode(value) else {
        return ""
    }
    return String(data: data, encoding: .utf8) ?? ""
}

func decode<T: Decodable>(_ string: String, fallback: T) -> T {
    guard let data = string.data(using: .utf8) else {
        return fallback
    }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return (try? decoder.decode(T.self, from: data)) ?? fallback
}
