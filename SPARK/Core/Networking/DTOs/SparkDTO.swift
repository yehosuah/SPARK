import Foundation

struct StimulusDTO: Codable {
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

    func toDomain() -> Stimulus {
        Stimulus(
            id: id,
            externalID: externalID,
            seedKey: seedKey,
            family: family,
            eyebrow: eyebrow,
            title: title,
            summary: summary,
            detailBody: detailBody,
            responseCue: responseCue,
            layoutEmphasis: layoutEmphasis,
            heroMediaID: heroMediaID,
            media: media,
            taxonomy: taxonomy,
            provenance: provenance,
            isFeatured: isFeatured,
            editorialPriority: editorialPriority,
            collectionKey: collectionKey,
            availabilityWindow: availabilityWindow,
            publishedAt: publishedAt,
            updatedAt: updatedAt,
            payload: payload
        )
    }
}
