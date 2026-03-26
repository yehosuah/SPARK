import Foundation

struct HomeFeed {
    var featuredStimulus: StimulusRecord
    var exploratoryStimuli: [StimulusRecord]
}

protocol StimulusFeedService: AnyObject {
    func loadHomeFeed(for profile: UserProfile?) async -> HomeFeed
    func loadDiscoverStimuli(for profile: UserProfile?) async -> [StimulusRecord]
}

@MainActor
final class DefaultStimulusFeedService: StimulusFeedService {
    private let stimulusRepository: any StimulusRepository
    private let stimulusGenerationService: any StimulusGenerationService
    private let apiClient: APIClient

    init(
        stimulusRepository: any StimulusRepository,
        stimulusGenerationService: any StimulusGenerationService,
        apiClient: APIClient
    ) {
        self.stimulusRepository = stimulusRepository
        self.stimulusGenerationService = stimulusGenerationService
        self.apiClient = apiClient
    }

    func loadHomeFeed(for profile: UserProfile?) async -> HomeFeed {
        let seeded = stimulusGenerationService.localStimuli(for: profile)
        try? stimulusRepository.upsert(contentsOf: seeded)

        let allRecords = ((try? stimulusRepository.fetchAll()) ?? [])
            .filter { !$0.isDismissed }
            .sorted(by: compareRecords)

        let featured = allRecords.first(where: \.isFeatured) ??
            StimulusRecord(
                stimulus: stimulusGenerationService.featuredStimulus(for: profile),
                state: StimulusState(stimulusID: stimulusGenerationService.featuredStimulus(for: profile).id)
            )

        let exploratory = Array(
            allRecords
                .filter { $0.id != featured.id && !$0.isFeatured }
                .prefix(Constants.homeSparkCount)
        )

        return HomeFeed(featuredStimulus: featured, exploratoryStimuli: exploratory)
    }

    func loadDiscoverStimuli(for profile: UserProfile?) async -> [StimulusRecord] {
        do {
            let remote = try await apiClient.request(Endpoint(path: "stimuli"), decode: [StimulusDTO].self)
            try? stimulusRepository.upsert(contentsOf: remote.map { $0.toDomain() })
        } catch {
            let seeded = stimulusGenerationService.localStimuli(for: profile)
            try? stimulusRepository.upsert(contentsOf: seeded)
        }

        return ((try? stimulusRepository.fetchAll()) ?? [])
            .filter { !$0.isDismissed }
            .sorted(by: compareRecords)
    }

    private func compareRecords(_ lhs: StimulusRecord, _ rhs: StimulusRecord) -> Bool {
        if lhs.isFeatured != rhs.isFeatured {
            return lhs.isFeatured && !rhs.isFeatured
        }
        if lhs.editorialPriority != rhs.editorialPriority {
            return lhs.editorialPriority > rhs.editorialPriority
        }
        return lhs.stimulus.publishedAt > rhs.stimulus.publishedAt
    }
}
