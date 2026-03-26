import Foundation

protocol StimulusGenerationService: AnyObject {
    func featuredStimulus(for profile: UserProfile?) -> Stimulus
    func localStimuli(for profile: UserProfile?) -> [Stimulus]
}

final class LocalStimulusGenerationService: StimulusGenerationService {
    func featuredStimulus(for profile: UserProfile?) -> Stimulus {
        let candidates = localStimuli(for: profile).filter(\.isFeatured)
        return candidates.first ?? fallbackStimuli.first!
    }

    func localStimuli(for profile: UserProfile?) -> [Stimulus] {
        let stimuli = loadSeeds() ?? fallbackStimuli
        guard let profile else { return stimuli }

        return stimuli.sorted { lhs, rhs in
            let leftDomainMatches = Set(lhs.taxonomy.domains).intersection(profile.interests).count
            let rightDomainMatches = Set(rhs.taxonomy.domains).intersection(profile.interests).count
            if leftDomainMatches == rightDomainMatches {
                let leftGoalMatches = Set(lhs.taxonomy.creativeGoalHints).intersection(profile.creativeIntents).count
                let rightGoalMatches = Set(rhs.taxonomy.creativeGoalHints).intersection(profile.creativeIntents).count
                if leftGoalMatches == rightGoalMatches {
                    return lhs.editorialPriority > rhs.editorialPriority
                }
                return leftGoalMatches > rightGoalMatches
            }
            return leftDomainMatches > rightDomainMatches
        }
    }

    private func loadSeeds() -> [Stimulus]? {
        guard let url = Bundle.main.url(forResource: "sample_stimuli", withExtension: "json", subdirectory: "Resources/SampleData") ??
                Bundle.main.url(forResource: "sample_stimuli", withExtension: "json") else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([StimulusDTO].self, from: Data(contentsOf: url)).map { $0.toDomain() }
    }

    private var fallbackStimuli: [Stimulus] {
        let artifactSource = StimulusSourceRef(
            sourceType: .internalSeed,
            title: "Kyoto hotel control wall",
            creator: "SPARK Editorial",
            citationNote: "Seeded local artifact reference"
        )
        let artifactMedia = StimulusMedia(
            role: .hero,
            storage: .systemSymbol("switch.2"),
            caption: "Hidden controls in a calm hospitality interior"
        )

        let caseMedia = StimulusMedia(
            role: .hero,
            storage: .systemSymbol("doc.text.image"),
            caption: "Founder memo with a strong point of view"
        )

        let contrastLeft = StimulusMedia(
            role: .left,
            storage: .systemSymbol("chart.bar.doc.horizontal"),
            caption: "Information-heavy product"
        )
        let contrastRight = StimulusMedia(
            role: .right,
            storage: .systemSymbol("scribble.variable"),
            caption: "Authored creative environment"
        )

        return [
            Stimulus(
                seedKey: "seed-artifact-quiet-capability",
                family: .artifact,
                eyebrow: "Featured stimulus",
                title: "Quiet capability",
                summary: "A boutique hotel hides every switch behind wood panels so the room feels calm before it feels capable.",
                detailBody: "The object is not just beautiful. It stages power as something the user discovers in peace. That emotional move can translate into software that reveals depth without proving itself loudly.",
                responseCue: "Where could your work replace visible feature density with discovered confidence?",
                layoutEmphasis: .visualHero,
                heroMediaID: artifactMedia.id,
                media: [artifactMedia],
                taxonomy: StimulusTaxonomy(
                    domains: [.design, .product, .technology],
                    creativeGoalHints: [.strongerTaste, .moreArtisticIntention],
                    keywords: ["restraint", "interface", "calm"],
                    editorialTags: ["premium", "quiet capability"]
                ),
                provenance: StimulusProvenance(
                    origin: .seededLocal,
                    sourceRefs: [artifactSource],
                    editorialMetadata: StimulusEditorialMetadata(
                        curatedTitle: "Quiet capability",
                        emphasisNote: "Visual artifact with a borrowable emotional move",
                        whyChosen: "A concrete object that makes restraint feel actionable.",
                        feedPriority: 100
                    )
                ),
                isFeatured: true,
                editorialPriority: 100,
                publishedAt: .now,
                updatedAt: .now,
                payload: .artifact(
                    ArtifactStimulusPayload(
                        artifactKind: "Interior control system",
                        observedObject: "A hidden control wall in a boutique hotel room",
                        focusPoints: [
                            "Capability is present but not announced.",
                            "Material treatment lowers cognitive noise.",
                            "Discovery feels intentional, not confusing."
                        ],
                        borrowableMove: "Stage power as discovered calm instead of visible abundance.",
                        artifactMediaNotes: "Look at how the concealment changes the felt tone of the room."
                    )
                )
            ),
            Stimulus(
                seedKey: "seed-case-founder-memo",
                family: .caseStudy,
                eyebrow: "Case",
                title: "Choosing a side sharpens the memo",
                summary: "The best founder memos do not sound comprehensive. They sound like someone finally chose a side.",
                detailBody: "The move is not adding more evidence. It is narrowing the frame until the reader can feel what the author believes and what the company should now refuse.",
                responseCue: "What are you still describing broadly instead of choosing decisively?",
                layoutEmphasis: .editorialHero,
                heroMediaID: caseMedia.id,
                media: [caseMedia],
                taxonomy: StimulusTaxonomy(
                    domains: [.strategy, .product, .writing],
                    creativeGoalHints: [.betterStrategicThinking, .sharperInsight],
                    keywords: ["memo", "authorship", "clarity"],
                    editorialTags: ["decision", "voice"]
                ),
                provenance: StimulusProvenance(
                    origin: .seededLocal,
                    sourceRefs: [
                        StimulusSourceRef(
                            sourceType: .internalSeed,
                            title: "Founder memo pattern",
                            creator: "SPARK Editorial",
                            citationNote: "Seeded local case synthesis"
                        )
                    ],
                    editorialMetadata: StimulusEditorialMetadata(
                        whyChosen: "Grounds originality in a real creative behavior.",
                        feedPriority: 90
                    )
                ),
                editorialPriority: 90,
                publishedAt: .now,
                updatedAt: .now,
                payload: .caseStudy(
                    CaseStimulusPayload(
                        caseSubject: "Founder memo",
                        situation: "A team needs direction after accumulating too many plausible options.",
                        move: "The memo narrows the frame and takes a position instead of expanding the analysis.",
                        outcome: "Readers leave with conviction, not just information.",
                        lesson: "Originality often appears when a writer chooses a side and accepts exclusion.",
                        evidenceNote: "Useful when a note feels informative but not decisive."
                    )
                )
            ),
            Stimulus(
                seedKey: "seed-pattern-felt-momentum",
                family: .pattern,
                eyebrow: "Pattern",
                title: "Felt momentum beats visible assistance",
                summary: "Tools feel more premium when the user notices their own momentum before they notice the interface.",
                detailBody: "The mechanism is simple: reduce proof-of-help moments and increase continuity of movement. The effect is confidence instead of dependency.",
                responseCue: "Where is your product interrupting the user just to prove it is helping?",
                layoutEmphasis: .mechanism,
                taxonomy: StimulusTaxonomy(
                    domains: [.design, .technology, .ai],
                    creativeGoalHints: [.betterProductThinking, .strongerTaste],
                    keywords: ["momentum", "premium", "interface"],
                    editorialTags: ["mechanism", "flow"]
                ),
                provenance: StimulusProvenance(
                    origin: .seededLocal,
                    sourceRefs: [
                        StimulusSourceRef(
                            sourceType: .internalSeed,
                            title: "Premium software interaction pattern",
                            citationNote: "Seeded local pattern synthesis"
                        )
                    ],
                    editorialMetadata: StimulusEditorialMetadata(
                        whyChosen: "Turns taste into a reusable mechanism.",
                        feedPriority: 85
                    )
                ),
                editorialPriority: 85,
                publishedAt: .now,
                updatedAt: .now,
                payload: .pattern(
                    PatternStimulusPayload(
                        patternName: "Felt momentum",
                        mechanism: "Minimize proof-of-help interruptions so progress feels self-authored.",
                        conditions: "Works best when the user is already trying to stay in cognitive flow.",
                        effect: "The interface feels premium because it leaves behind confidence.",
                        whereItApplies: "Creative tools, AI surfaces, guided workflows, and product onboarding.",
                        misuseWarning: "Do not hide necessary orientation or create ambiguity in the name of elegance."
                    )
                )
            ),
            Stimulus(
                seedKey: "seed-contrast-authorship",
                family: .contrast,
                eyebrow: "Contrast",
                title: "Informed vs authored",
                summary: "One product makes you feel informed. Another makes you feel authored. The gap is rarely information.",
                detailBody: "The tension is not feature breadth versus feature depth. It is the emotional difference between delivering facts and strengthening point of view.",
                responseCue: "Which side is your current work leaving the user on?",
                layoutEmphasis: .splitComparison,
                media: [contrastLeft, contrastRight],
                taxonomy: StimulusTaxonomy(
                    domains: [.product, .design, .startups],
                    creativeGoalHints: [.betterProductThinking, .moreOriginalIdeas],
                    keywords: ["authorship", "product", "tension"],
                    editorialTags: ["comparison", "taste"]
                ),
                provenance: StimulusProvenance(
                    origin: .seededLocal,
                    sourceRefs: [
                        StimulusSourceRef(
                            sourceType: .internalSeed,
                            title: "Product authorship contrast",
                            citationNote: "Seeded local editorial contrast"
                        )
                    ],
                    editorialMetadata: StimulusEditorialMetadata(
                        whyChosen: "Sharpens the taste bar through side-by-side tension.",
                        feedPriority: 80
                    )
                ),
                editorialPriority: 80,
                publishedAt: .now,
                updatedAt: .now,
                payload: .contrast(
                    ContrastStimulusPayload(
                        leftSide: ContrastSide(
                            label: "Informed",
                            summary: "The user receives more information, options, and explanations.",
                            mediaID: contrastLeft.id
                        ),
                        rightSide: ContrastSide(
                            label: "Authored",
                            summary: "The user leaves feeling more directed, shaped, and capable.",
                            mediaID: contrastRight.id
                        ),
                        comparisonAxis: "Emotional outcome after use",
                        tension: "Information increases volume. Authorship increases point of view.",
                        editorialTake: "If the product wants to feel premium, optimize for the after-feeling, not the visible amount of help."
                    )
                )
            ),
            Stimulus(
                seedKey: "seed-collision-fashion-memo",
                family: .collision,
                eyebrow: "Collision",
                title: "Finance memo x fashion criticism",
                summary: "What happens if venture memos borrow more from fashion criticism than management consulting?",
                detailBody: "The goal is not novelty theater. It is using the collision to invent a new voice: sharper taste language, fewer false certainties, more attention to texture and mood.",
                responseCue: "Which two worlds would force your work into a fresher voice?",
                layoutEmphasis: .synthesis,
                taxonomy: StimulusTaxonomy(
                    domains: [.finance, .markets, .writing],
                    creativeGoalHints: [.moreOriginalIdeas, .moreExpressiveThinking],
                    keywords: ["voice", "synthesis", "memo"],
                    editorialTags: ["collision", "novelty"]
                ),
                provenance: StimulusProvenance(
                    origin: .seededLocal,
                    sourceRefs: [
                        StimulusSourceRef(
                            sourceType: .internalSeed,
                            title: "Cross-domain writing collision",
                            citationNote: "Seeded local collision prompt"
                        )
                    ],
                    editorialMetadata: StimulusEditorialMetadata(
                        whyChosen: "Creates novelty through a concrete cross-domain synthesis.",
                        feedPriority: 78
                    )
                ),
                editorialPriority: 78,
                publishedAt: .now,
                updatedAt: .now,
                payload: .collision(
                    CollisionStimulusPayload(
                        worldA: "Venture memo",
                        worldB: "Fashion criticism",
                        collisionPremise: "Use criticism language to describe strategic positions with more taste and texture.",
                        synthesisDirection: "Invent a financial writing voice that judges positioning like design, not just performance like a spreadsheet.",
                        buildAngle: "Try rewriting one dry strategic note using the sensory and evaluative language of criticism."
                    )
                )
            )
        ]
    }
}
