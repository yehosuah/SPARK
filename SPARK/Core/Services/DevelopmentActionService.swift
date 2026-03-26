import Foundation

struct DevelopmentSuggestion: Equatable {
    var action: DevelopmentAction
    var content: String
}

protocol DevelopmentActionService: AnyObject {
    func run(
        action: DevelopmentAction,
        on idea: IdeaSheet,
        sourceStimulus: Stimulus?,
        profile: UserProfile?
    ) async -> DevelopmentSuggestion
}

final class DefaultDevelopmentActionService: DevelopmentActionService {
    private let aiProvider: AIProvider
    private let promptBuilder: PromptBuilder
    private let responseParser: AIResponseParser

    init(
        aiProvider: AIProvider,
        promptBuilder: PromptBuilder,
        responseParser: AIResponseParser
    ) {
        self.aiProvider = aiProvider
        self.promptBuilder = promptBuilder
        self.responseParser = responseParser
    }

    func run(
        action: DevelopmentAction,
        on idea: IdeaSheet,
        sourceStimulus: Stimulus?,
        profile: UserProfile?
    ) async -> DevelopmentSuggestion {
        let prompt = promptBuilder.buildPrompt(for: action, idea: idea, sourceStimulus: sourceStimulus, profile: profile)
        do {
            let generated = try await aiProvider.generate(prompt: prompt)
            return DevelopmentSuggestion(action: action, content: responseParser.parse(generated))
        } catch {
            return DevelopmentSuggestion(action: action, content: fallbackSuggestion(for: action, idea: idea, sourceStimulus: sourceStimulus))
        }
    }

    private func fallbackSuggestion(for action: DevelopmentAction, idea: IdeaSheet, sourceStimulus: Stimulus?) -> String {
        let domainTitle = sourceStimulus?.taxonomy.domains.first?.title ?? "a domain you care about"
        switch action {
        case .reframe:
            return """
            - Reframe this around the shift in perception, not the object being described.
            - Ask what becomes newly true if this note is right.
            - Remove any line that explains before it takes a stance.
            """
        case .findTension:
            return """
            - The live tension is between clarity and abundance, not between good and bad execution.
            - Name what this idea refuses, because refusal is where its shape starts to appear.
            - Ask what tradeoff makes the note more valuable rather than more complete.
            """
        case .makeBolder:
            return """
            - Replace the safest sentence with the version that would make a smart reader argue back.
            - Push the note toward a claim you would be willing to sign your name to.
            - Let the idea risk exclusion so it can gain shape.
            """
        case .makeMoreOriginal:
            return """
            - Swap the default language for a fresher lens, object, or metaphor.
            - Move one layer away from trend language and one layer closer to lived detail.
            - Ask what only this note, from this mind, could notice.
            """
        case .turnIntoConcept:
            return """
            - Name the concept in 2 to 4 words before you describe it.
            - State the emotional shift it creates for the user or reader.
            - Define what makes it different from a note, feature, or generic insight.
            """
        case .connectToDomain:
            return """
            - Translate this note into the language of \(domainTitle) without flattening it.
            - Ask what \(domainTitle.lowercased()) reveals about the leverage or taste inside the idea.
            - Use the domain bridge to sharpen the note, not to decorate it.
            """
        case .namePrinciple:
            return """
            - The principle may be that people trust restraint more than visible abundance.
            - Try naming the governing idea as a reusable rule, not a one-off observation.
            - If the principle feels too broad, make it falsifiable.
            """
        case .changeScale:
            return """
            - Shrink the note until it becomes one specific move someone could make tomorrow.
            - Expand it until it becomes a cultural or strategic pattern instead of a local observation.
            - Notice which scale makes the idea feel more alive.
            """
        }
    }
}
