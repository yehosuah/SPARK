import Testing
@testable import SPARK

private final class FailingAIProvider: AIProvider {
    func generate(prompt: String) async throws -> String {
        throw NetworkError.missingBaseURL
    }
}

struct DevelopmentActionServiceTests {
    @Test
    func fallsBackWhenNoBackendExists() async {
        let service = DefaultDevelopmentActionService(
            aiProvider: FailingAIProvider(),
            promptBuilder: PromptBuilder(),
            responseParser: AIResponseParser()
        )

        let suggestion = await service.run(
            action: .reframe,
            on: IdeaSheet(title: "Title", body: "A rough idea that needs shape."),
            sourceStimulus: nil,
            profile: nil
        )

        #expect(!suggestion.content.isEmpty)
    }
}
