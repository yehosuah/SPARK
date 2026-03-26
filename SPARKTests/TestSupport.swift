import Foundation
@testable import SPARK

@MainActor
func makeTestContainer(userDefaults: UserDefaults = .standard) -> AppContainer {
    let persistenceController = PersistenceController(inMemory: true)
    let modelContext = persistenceController.mainContext
    let stimulusRepository = SwiftDataStimulusRepository(modelContext: modelContext)
    let ideaRepository = SwiftDataIdeaRepository(modelContext: modelContext)
    let draftRepository = SwiftDataDraftRepository(modelContext: modelContext)
    let userProfileRepository = SwiftDataUserProfileRepository(modelContext: modelContext)
    let resurfacingRepository = UserDefaultsResurfacingRepository(userDefaults: userDefaults)
    let environment = AppEnvironment.preview
    let apiClient = DefaultAPIClient(environment: environment)
    let aiProvider = DefaultAIProvider(apiClient: apiClient)
    let stimulusGenerationService = LocalStimulusGenerationService()
    let captureService = DefaultCaptureService(
        draftRepository: draftRepository,
        ideaRepository: ideaRepository,
        stimulusRepository: stimulusRepository
    )
    let developmentActionService = DefaultDevelopmentActionService(
        aiProvider: aiProvider,
        promptBuilder: PromptBuilder(),
        responseParser: AIResponseParser()
    )
    let searchService = DefaultSearchService(
        ideaRepository: ideaRepository,
        stimulusRepository: stimulusRepository,
        draftRepository: draftRepository
    )
    let onboardingService = DefaultOnboardingService(userProfileRepository: userProfileRepository)
    let resurfacingService = DefaultResurfacingService(
        ideaRepository: ideaRepository,
        stimulusRepository: stimulusRepository,
        resurfacingRepository: resurfacingRepository
    )
    let voiceCaptureService = DefaultVoiceCaptureService()
    let sketchService = DefaultSketchService()
    let stimulusFeedService = DefaultStimulusFeedService(
        stimulusRepository: stimulusRepository,
        stimulusGenerationService: stimulusGenerationService,
        apiClient: apiClient
    )

    return AppContainer(
        environment: environment,
        persistenceController: persistenceController,
        services: ServiceRegistry(
            stimulusRepository: stimulusRepository,
            ideaRepository: ideaRepository,
            draftRepository: draftRepository,
            userProfileRepository: userProfileRepository,
            resurfacingRepository: resurfacingRepository,
            stimulusFeedService: stimulusFeedService,
            stimulusGenerationService: stimulusGenerationService,
            captureService: captureService,
            voiceCaptureService: voiceCaptureService,
            sketchService: sketchService,
            developmentActionService: developmentActionService,
            resurfacingService: resurfacingService,
            searchService: searchService,
            onboardingService: onboardingService
        )
    )
}
