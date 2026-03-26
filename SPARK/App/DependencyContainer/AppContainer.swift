import Foundation
import Observation

@Observable
@MainActor
final class AppContainer {
    let environment: AppEnvironment
    let persistenceController: PersistenceController
    let services: ServiceRegistry

    init(
        environment: AppEnvironment,
        persistenceController: PersistenceController,
        services: ServiceRegistry
    ) {
        self.environment = environment
        self.persistenceController = persistenceController
        self.services = services
    }

    static func live(persistenceController: PersistenceController) -> AppContainer {
        let environment = AppEnvironment.live
        let modelContext = persistenceController.mainContext
        let stimulusRepository = SwiftDataStimulusRepository(modelContext: modelContext)
        let ideaRepository = SwiftDataIdeaRepository(modelContext: modelContext)
        let draftRepository = SwiftDataDraftRepository(modelContext: modelContext)
        let userProfileRepository = SwiftDataUserProfileRepository(modelContext: modelContext)
        let resurfacingRepository = UserDefaultsResurfacingRepository()
        let apiClient = DefaultAPIClient(environment: environment)
        let aiProvider = DefaultAIProvider(apiClient: apiClient)
        let stimulusGenerationService = LocalStimulusGenerationService()
        let voiceCaptureService = DefaultVoiceCaptureService()
        let sketchService = DefaultSketchService()
        let captureService = DefaultCaptureService(
            draftRepository: draftRepository,
            ideaRepository: ideaRepository,
            stimulusRepository: stimulusRepository
        )
        let stimulusFeedService = DefaultStimulusFeedService(
            stimulusRepository: stimulusRepository,
            stimulusGenerationService: stimulusGenerationService,
            apiClient: apiClient
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
}
