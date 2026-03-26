import Foundation

struct PromptBuilder {
    func buildPrompt(
        for action: DevelopmentAction,
        idea: IdeaSheet,
        sourceStimulus: Stimulus?,
        profile: UserProfile?
    ) -> String {
        let domainTitle = suggestedDomain(from: sourceStimulus, profile: profile)
        var sections: [String] = []
        sections.append("You are helping shape a user's idea inside a premium creativity studio.")
        sections.append("Do not finish the idea for them and do not write polished paragraphs.")
        sections.append(DevelopmentActionPrompts.instruction(for: action, domainTitle: domainTitle))
        if let sourceStimulus {
            sections.append("Source stimulus family: \(sourceStimulus.family.title)")
            sections.append("Source stimulus title: \(sourceStimulus.title)")
            sections.append("Source stimulus summary: \(sourceStimulus.summary)")
            sections.append("Source stimulus detail: \(sourceStimulus.detailBody ?? sourceStimulus.summary)")
            sections.append("Structured hooks: \(payloadSummary(for: sourceStimulus))")
        }
        if let profile, !profile.interests.isEmpty {
            let interests = profile.interests.map(\.title).joined(separator: ", ")
            sections.append("Their current interest domains: \(interests)")
        }
        if let domainTitle {
            sections.append("Preferred domain bridge: \(domainTitle)")
        }
        sections.append("Idea title: \(idea.resolvedTitle)")
        sections.append("Idea body: \(idea.body)")
        sections.append("Return exactly 3 bullet points.")
        sections.append("Each bullet must be one sentence, concrete, and catalytic.")
        sections.append("Avoid motivational language, filler, task lists, and generic AI phrasing.")
        return sections.joined(separator: "\n\n")
    }

    private func suggestedDomain(from sourceStimulus: Stimulus?, profile: UserProfile?) -> String? {
        if let firstDomain = sourceStimulus?.taxonomy.domains.first {
            return firstDomain.title
        }
        return profile?.interests.first?.title
    }

    private func payloadSummary(for stimulus: Stimulus) -> String {
        switch stimulus.payload {
        case .artifact(let payload):
            return "Observed object: \(payload.observedObject). Borrowable move: \(payload.borrowableMove). Focus points: \(payload.focusPoints.joined(separator: "; "))"
        case .caseStudy(let payload):
            return "Situation: \(payload.situation). Move: \(payload.move). Outcome: \(payload.outcome). Lesson: \(payload.lesson)"
        case .contrast(let payload):
            return "Axis: \(payload.comparisonAxis). Left: \(payload.leftSide.label) - \(payload.leftSide.summary). Right: \(payload.rightSide.label) - \(payload.rightSide.summary). Tension: \(payload.tension)"
        case .pattern(let payload):
            return "Pattern: \(payload.patternName). Mechanism: \(payload.mechanism). Conditions: \(payload.conditions). Effect: \(payload.effect)"
        case .collision(let payload):
            return "World A: \(payload.worldA). World B: \(payload.worldB). Premise: \(payload.collisionPremise). Synthesis: \(payload.synthesisDirection)"
        }
    }
}
