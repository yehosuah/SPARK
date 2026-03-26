import Foundation
import Testing
@testable import SPARK

@MainActor
struct ModelMappingTests {
    @Test
    func ideaSheetRoundTripPreservesAttachmentsAndTags() {
        let idea = IdeaSheet(
            title: "Taste as leverage",
            body: "A note worth keeping.",
            inferredTitle: false,
            primaryStimulusID: UUID(),
            stimulusLinks: [
                StimulusLink(
                    stimulusID: UUID(),
                    relation: .builtFrom,
                    snapshotTitle: "Quiet capability",
                    snapshotFamilyRaw: StimulusFamily.artifact.rawValue
                )
            ],
            attachments: [
                .voice(VoiceAttachment(filePath: "/tmp/voice.m4a", duration: 12, transcription: "hello")),
                .sketch(SketchAttachment(filePath: "/tmp/sketch.drawing", note: "flow"))
            ],
            tags: [Tag(name: "ai"), Tag(name: "design")],
            contextMarker: "Concept",
            status: .active,
            revisionCount: 2
        )

        let persistent = IdeaSheetMapper.makePersistent(from: idea)
        let roundTrip = IdeaSheetMapper.toDomain(persistent)

        #expect(roundTrip.title == idea.title)
        #expect(roundTrip.attachments.count == 2)
        #expect(roundTrip.tags.map(\.name) == ["ai", "design"])
        #expect(roundTrip.contextMarker == "Concept")
        #expect(roundTrip.stimulusLinks.count == 1)
    }
}
