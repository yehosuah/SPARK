import Foundation
@testable import SPARK

final class MockDevelopmentActionService: DevelopmentActionService {
    var stubbedSuggestion = DevelopmentSuggestion(action: .reframe, content: "A clearer angle.")

    func run(
        action: DevelopmentAction,
        on idea: IdeaSheet,
        sourceStimulus: Stimulus?,
        profile: UserProfile?
    ) async -> DevelopmentSuggestion {
        stubbedSuggestion
    }
}
