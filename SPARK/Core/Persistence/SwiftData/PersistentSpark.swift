import Foundation
import SwiftData

@Model
final class PersistentStimulus {
    @Attribute(.unique) var id: UUID
    var externalID: String?
    var seedKey: String?
    var familyRaw: String
    var eyebrow: String?
    var title: String
    var summary: String
    var detailBody: String?
    var responseCue: String?
    var layoutEmphasisRaw: String
    var heroMediaID: UUID?
    var mediaJSON: String
    var taxonomyJSON: String
    var provenanceJSON: String
    var payloadJSON: String
    var isFeatured: Bool
    var editorialPriority: Int
    var collectionKey: String?
    var availabilityWindowJSON: String
    var primaryDomainRaw: String?
    var publishedAt: Date
    var updatedAt: Date

    init(
        id: UUID,
        externalID: String?,
        seedKey: String?,
        familyRaw: String,
        eyebrow: String?,
        title: String,
        summary: String,
        detailBody: String?,
        responseCue: String?,
        layoutEmphasisRaw: String,
        heroMediaID: UUID?,
        mediaJSON: String,
        taxonomyJSON: String,
        provenanceJSON: String,
        payloadJSON: String,
        isFeatured: Bool,
        editorialPriority: Int,
        collectionKey: String?,
        availabilityWindowJSON: String,
        primaryDomainRaw: String?,
        publishedAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.externalID = externalID
        self.seedKey = seedKey
        self.familyRaw = familyRaw
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.detailBody = detailBody
        self.responseCue = responseCue
        self.layoutEmphasisRaw = layoutEmphasisRaw
        self.heroMediaID = heroMediaID
        self.mediaJSON = mediaJSON
        self.taxonomyJSON = taxonomyJSON
        self.provenanceJSON = provenanceJSON
        self.payloadJSON = payloadJSON
        self.isFeatured = isFeatured
        self.editorialPriority = editorialPriority
        self.collectionKey = collectionKey
        self.availabilityWindowJSON = availabilityWindowJSON
        self.primaryDomainRaw = primaryDomainRaw
        self.publishedAt = publishedAt
        self.updatedAt = updatedAt
    }
}
