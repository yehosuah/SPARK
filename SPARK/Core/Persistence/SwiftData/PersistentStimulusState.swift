import Foundation
import SwiftData

@Model
final class PersistentStimulusState {
    @Attribute(.unique) var stimulusID: UUID
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
}
