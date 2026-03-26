import Foundation

@MainActor
final class ServiceRegistry {
    let stimulusRepository: any StimulusRepository
    let ideaRepository: any IdeaRepository
    let draftRepository: any DraftRepository
    let userProfileRepository: any UserProfileRepository
    let resurfacingRepository: any ResurfacingRepository

    let stimulusFeedService: any StimulusFeedService
    let stimulusGenerationService: any StimulusGenerationService
    let captureService: any CaptureService
    let voiceCaptureService: any VoiceCaptureService
    let sketchService: any SketchService
    let developmentActionService: any DevelopmentActionService
    let resurfacingService: any ResurfacingService
    let searchService: any SearchService
    let onboardingService: any OnboardingService

    init(
        stimulusRepository: any StimulusRepository,
        ideaRepository: any IdeaRepository,
        draftRepository: any DraftRepository,
        userProfileRepository: any UserProfileRepository,
        resurfacingRepository: any ResurfacingRepository,
        stimulusFeedService: any StimulusFeedService,
        stimulusGenerationService: any StimulusGenerationService,
        captureService: any CaptureService,
        voiceCaptureService: any VoiceCaptureService,
        sketchService: any SketchService,
        developmentActionService: any DevelopmentActionService,
        resurfacingService: any ResurfacingService,
        searchService: any SearchService,
        onboardingService: any OnboardingService
    ) {
        self.stimulusRepository = stimulusRepository
        self.ideaRepository = ideaRepository
        self.draftRepository = draftRepository
        self.userProfileRepository = userProfileRepository
        self.resurfacingRepository = resurfacingRepository
        self.stimulusFeedService = stimulusFeedService
        self.stimulusGenerationService = stimulusGenerationService
        self.captureService = captureService
        self.voiceCaptureService = voiceCaptureService
        self.sketchService = sketchService
        self.developmentActionService = developmentActionService
        self.resurfacingService = resurfacingService
        self.searchService = searchService
        self.onboardingService = onboardingService
    }
}
