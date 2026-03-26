import Foundation

protocol CaptureService: AnyObject {
    func createDraft(mode: CaptureMode, stimulusID: UUID?, relation: StimulusLinkRelation) -> Draft
    func saveDraft(_ draft: Draft) throws
    func loadDraft(id: UUID) throws -> Draft?
    func discardDraft(id: UUID) throws
    func promoteDraftToIdeaSheet(_ draft: Draft) throws -> IdeaSheet
    func createIdeaFromStimulus(_ stimulus: Stimulus, relation: StimulusLinkRelation) throws -> IdeaSheet
}

@MainActor
final class DefaultCaptureService: CaptureService {
    private let draftRepository: any DraftRepository
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository

    init(
        draftRepository: any DraftRepository,
        ideaRepository: any IdeaRepository,
        stimulusRepository: any StimulusRepository
    ) {
        self.draftRepository = draftRepository
        self.ideaRepository = ideaRepository
        self.stimulusRepository = stimulusRepository
    }

    func createDraft(
        mode: CaptureMode,
        stimulusID: UUID? = nil,
        relation: StimulusLinkRelation = .respondingTo
    ) -> Draft {
        let link = stimulusID.flatMap { id in
            (try? stimulusRepository.stimulus(id: id))?.makeLink(relation: relation)
        }
        return Draft(
            mode: mode,
            primaryStimulusID: stimulusID,
            stimulusLinks: link.map { [$0] } ?? []
        )
    }

    func saveDraft(_ draft: Draft) throws {
        try draftRepository.save(draft)
    }

    func loadDraft(id: UUID) throws -> Draft? {
        try draftRepository.fetch(id: id)
    }

    func discardDraft(id: UUID) throws {
        try draftRepository.delete(id)
    }

    func promoteDraftToIdeaSheet(_ draft: Draft) throws -> IdeaSheet {
        let idea = IdeaSheet(
            title: draft.titleCandidate,
            body: draft.text,
            inferredTitle: true,
            primaryStimulusID: draft.primaryStimulusID,
            stimulusLinks: draft.stimulusLinks,
            attachments: draft.attachments,
            tags: draft.tags,
            createdAt: draft.createdAt,
            updatedAt: .now,
            lastOpenedAt: .now,
            revisionCount: 1
        )
        try ideaRepository.save(idea)
        var promotedDraft = draft
        promotedDraft.wasPromoted = true
        try draftRepository.save(promotedDraft)
        for link in draft.stimulusLinks {
            switch link.relation {
            case .builtFrom:
                try stimulusRepository.incrementBuildCount(for: link.stimulusID)
            case .respondingTo, .savedFrom:
                try stimulusRepository.incrementResponseCount(for: link.stimulusID)
            }
        }
        return idea
    }

    func createIdeaFromStimulus(_ stimulus: Stimulus, relation: StimulusLinkRelation = .builtFrom) throws -> IdeaSheet {
        let link = stimulus.makeLink(relation: relation)
        let idea = IdeaSheet(
            title: nil,
            body: "",
            inferredTitle: true,
            primaryStimulusID: stimulus.id,
            stimulusLinks: [link],
            attachments: [],
            tags: stimulus.taxonomy.domains.map { Tag(name: $0.title) },
            createdAt: .now,
            updatedAt: .now,
            lastOpenedAt: .now
        )
        try ideaRepository.save(idea)
        try stimulusRepository.upsert(stimulus)
        switch relation {
        case .builtFrom:
            try stimulusRepository.incrementBuildCount(for: stimulus.id)
        case .respondingTo, .savedFrom:
            try stimulusRepository.incrementResponseCount(for: stimulus.id)
        }
        return idea
    }
}
