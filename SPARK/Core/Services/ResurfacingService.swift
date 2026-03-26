import Foundation

protocol ResurfacingService: AnyObject {
    func homeCandidate() throws -> ResurfacedItem?
    func libraryCandidates(limit: Int) throws -> [ResurfacedItem]
    func dismiss(_ item: ResurfacedItem)
}

@MainActor
final class DefaultResurfacingService: ResurfacingService {
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository
    private let resurfacingRepository: any ResurfacingRepository

    init(
        ideaRepository: any IdeaRepository,
        stimulusRepository: any StimulusRepository,
        resurfacingRepository: any ResurfacingRepository
    ) {
        self.ideaRepository = ideaRepository
        self.stimulusRepository = stimulusRepository
        self.resurfacingRepository = resurfacingRepository
    }

    func homeCandidate() throws -> ResurfacedItem? {
        try libraryCandidates(limit: 1).first
    }

    func libraryCandidates(limit: Int) throws -> [ResurfacedItem] {
        let ideas = try ideaRepository.fetchAll()
        let stimuli = try stimulusRepository.fetchSaved()
        let now = Date()
        let recentIdeas = ideas.filter {
            $0.updatedAt >= Calendar.current.date(byAdding: .day, value: -Constants.thematicEchoDays, to: now) ?? .distantPast
        }

        var candidates: [ResurfacedItem] = []

        for idea in ideas where !resurfacingRepository.isDismissed(key: resurfacingKey(for: .idea(idea.id))) {
            let daysSinceOpen = Calendar.current.dateComponents([.day], from: idea.lastOpenedAt, to: now).day ?? 0
            if idea.isUnfinished && daysSinceOpen >= Constants.forgottenIdeaDays {
                candidates.append(
                    ResurfacedItem(
                        kind: .idea(idea.id),
                        title: idea.resolvedTitle,
                        preview: idea.previewText,
                        reason: "You may want to return to this.",
                        score: 0.92
                    )
                )
            } else if idea.revisionCount >= 2 && now.timeIntervalSince(idea.updatedAt) >= Double(Constants.momentumIdleHours * 3600) {
                candidates.append(
                    ResurfacedItem(
                        kind: .idea(idea.id),
                        title: idea.resolvedTitle,
                        preview: idea.previewText,
                        reason: "You were onto something here.",
                        score: 0.86
                    )
                )
            } else if recentIdeas.contains(where: { other in
                let otherTags = Set(other.tags.map { $0.name.lowercased() })
                let ideaTags = Set(idea.tags.map { $0.name.lowercased() })
                let sharesStimulus = Set(other.stimulusLinks.map(\.stimulusID)).intersection(idea.stimulusLinks.map(\.stimulusID)).isEmpty == false
                return other.id != idea.id && (!otherTags.intersection(ideaTags).isEmpty || sharesStimulus)
            }) {
                candidates.append(
                    ResurfacedItem(
                        kind: .idea(idea.id),
                        title: idea.resolvedTitle,
                        preview: idea.previewText,
                        reason: "This connects to what you've been exploring.",
                        score: 0.8
                    )
                )
            }
        }

        for stimulus in stimuli where !resurfacingRepository.isDismissed(key: resurfacingKey(for: .stimulus(stimulus.id))) {
            let daysSinceSaved = Calendar.current.dateComponents([.day], from: stimulus.state.savedAt ?? stimulus.stimulus.publishedAt, to: now).day ?? 0
            if stimulus.buildCount == 0 && stimulus.responseCount == 0 && daysSinceSaved >= Constants.unusedSparkDays {
                candidates.append(
                    ResurfacedItem(
                        kind: .stimulus(stimulus.id),
                        title: stimulus.title,
                        preview: stimulus.summary,
                        reason: "This still has something in it.",
                        score: 0.84
                    )
                )
            }
        }

        return candidates
            .sorted { lhs, rhs in
                if lhs.score == rhs.score {
                    return lhs.title < rhs.title
                }
                return lhs.score > rhs.score
            }
            .prefix(limit)
            .map { $0 }
    }

    func dismiss(_ item: ResurfacedItem) {
        resurfacingRepository.dismiss(key: resurfacingKey(for: item.kind))
    }

    private func resurfacingKey(for kind: ResurfacedItem.Kind) -> String {
        switch kind {
        case .idea(let id):
            return "idea.\(id.uuidString)"
        case .stimulus(let id):
            return "stimulus.\(id.uuidString)"
        }
    }
}
