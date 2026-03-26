import Foundation

struct SearchResults {
    var ideas: [IdeaSheet]
    var stimuli: [StimulusRecord]
    var drafts: [Draft]
}

protocol SearchService: AnyObject {
    func search(query: String) throws -> SearchResults
}

@MainActor
final class DefaultSearchService: SearchService {
    private let ideaRepository: any IdeaRepository
    private let stimulusRepository: any StimulusRepository
    private let draftRepository: any DraftRepository

    init(
        ideaRepository: any IdeaRepository,
        stimulusRepository: any StimulusRepository,
        draftRepository: any DraftRepository
    ) {
        self.ideaRepository = ideaRepository
        self.stimulusRepository = stimulusRepository
        self.draftRepository = draftRepository
    }

    func search(query: String) throws -> SearchResults {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else {
            return SearchResults(
                ideas: try ideaRepository.fetchAll(),
                stimuli: try stimulusRepository.fetchSaved(),
                drafts: try draftRepository.fetchAll()
            )
        }

        return SearchResults(
            ideas: try ideaRepository.fetchAll().filter {
                $0.resolvedTitle.lowercased().contains(normalized) ||
                $0.body.lowercased().contains(normalized) ||
                $0.tags.contains(where: { $0.name.lowercased().contains(normalized) })
            },
            stimuli: try stimulusRepository.fetchSaved().filter {
                $0.stimulus.searchableText.lowercased().contains(normalized)
            },
            drafts: try draftRepository.fetchAll().filter {
                $0.text.lowercased().contains(normalized) ||
                $0.stimulusLinks.contains {
                    $0.snapshotTitle.lowercased().contains(normalized) ||
                    ($0.snapshotSummary?.lowercased().contains(normalized) == true)
                }
            }
        )
    }
}
