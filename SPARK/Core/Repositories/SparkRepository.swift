import Foundation
import SwiftData

@MainActor
protocol StimulusRepository: AnyObject {
    func fetchAll() throws -> [StimulusRecord]
    func fetchSaved() throws -> [StimulusRecord]
    func stimulus(id: UUID) throws -> Stimulus?
    func record(id: UUID) throws -> StimulusRecord?
    func upsert(_ stimulus: Stimulus) throws
    func upsert(contentsOf stimuli: [Stimulus]) throws
    func setSaved(_ isSaved: Bool, for stimulusID: UUID) throws
    func setDismissed(_ isDismissed: Bool, for stimulusID: UUID) throws
    func markViewed(_ stimulusID: UUID) throws
    func incrementResponseCount(for stimulusID: UUID) throws
    func incrementBuildCount(for stimulusID: UUID) throws
}

@MainActor
final class SwiftDataStimulusRepository: StimulusRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [StimulusRecord] {
        let stimuli = try modelContext.fetch(FetchDescriptor<PersistentStimulus>())
        let states = try fetchStateMap()
        return stimuli.map { persistent in
            let stimulus = StimulusMapper.toDomain(persistent)
            let state = states[stimulus.id] ?? StimulusState(stimulusID: stimulus.id)
            return StimulusRecord(stimulus: stimulus, state: state)
        }
        .sorted { lhs, rhs in
            if lhs.isFeatured != rhs.isFeatured {
                return lhs.isFeatured && !rhs.isFeatured
            }
            if lhs.editorialPriority != rhs.editorialPriority {
                return lhs.editorialPriority > rhs.editorialPriority
            }
            return lhs.stimulus.publishedAt > rhs.stimulus.publishedAt
        }
    }

    func fetchSaved() throws -> [StimulusRecord] {
        let stateDescriptor = FetchDescriptor<PersistentStimulusState>(
            predicate: #Predicate { $0.isSaved == true }
        )
        let savedStates = try modelContext.fetch(stateDescriptor)
        return try savedStates.compactMap { state in
            guard let stimulus = try fetchPersistentStimulus(id: state.stimulusID) else { return nil }
            return StimulusRecord(
                stimulus: StimulusMapper.toDomain(stimulus),
                state: StimulusMapper.toState(state)
            )
        }
        .sorted { lhs, rhs in
            (lhs.state.savedAt ?? lhs.stimulus.publishedAt) > (rhs.state.savedAt ?? rhs.stimulus.publishedAt)
        }
    }

    func stimulus(id: UUID) throws -> Stimulus? {
        try fetchPersistentStimulus(id: id).map(StimulusMapper.toDomain)
    }

    func record(id: UUID) throws -> StimulusRecord? {
        guard let stimulus = try fetchPersistentStimulus(id: id) else { return nil }
        let state = try fetchPersistentState(stimulusID: id)
        return StimulusRecord(
            stimulus: StimulusMapper.toDomain(stimulus),
            state: state.map(StimulusMapper.toState) ?? StimulusState(stimulusID: id)
        )
    }

    func upsert(_ stimulus: Stimulus) throws {
        if let existing = try fetchPersistentStimulus(id: stimulus.id) {
            StimulusMapper.update(existing, with: stimulus)
        } else {
            modelContext.insert(StimulusMapper.makePersistent(from: stimulus))
        }
        try modelContext.save()
    }

    func upsert(contentsOf stimuli: [Stimulus]) throws {
        for stimulus in stimuli {
            if let existing = try fetchPersistentStimulus(id: stimulus.id) {
                StimulusMapper.update(existing, with: stimulus)
            } else {
                modelContext.insert(StimulusMapper.makePersistent(from: stimulus))
            }
        }
        try modelContext.save()
    }

    func setSaved(_ isSaved: Bool, for stimulusID: UUID) throws {
        let state = try ensurePersistentState(stimulusID: stimulusID)
        state.isSaved = isSaved
        state.savedAt = isSaved ? .now : nil
        try modelContext.save()
    }

    func setDismissed(_ isDismissed: Bool, for stimulusID: UUID) throws {
        let state = try ensurePersistentState(stimulusID: stimulusID)
        state.isDismissed = isDismissed
        try modelContext.save()
    }

    func markViewed(_ stimulusID: UUID) throws {
        let state = try ensurePersistentState(stimulusID: stimulusID)
        state.lastViewedAt = .now
        try modelContext.save()
    }

    func incrementResponseCount(for stimulusID: UUID) throws {
        let state = try ensurePersistentState(stimulusID: stimulusID)
        state.responseCount += 1
        try modelContext.save()
    }

    func incrementBuildCount(for stimulusID: UUID) throws {
        let state = try ensurePersistentState(stimulusID: stimulusID)
        state.buildCount += 1
        try modelContext.save()
    }

    private func fetchStateMap() throws -> [UUID: StimulusState] {
        try modelContext.fetch(FetchDescriptor<PersistentStimulusState>())
            .reduce(into: [UUID: StimulusState]()) { partialResult, persistent in
                partialResult[persistent.stimulusID] = StimulusMapper.toState(persistent)
            }
    }

    private func fetchPersistentStimulus(id: UUID) throws -> PersistentStimulus? {
        var descriptor = FetchDescriptor<PersistentStimulus>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func fetchPersistentState(stimulusID: UUID) throws -> PersistentStimulusState? {
        var descriptor = FetchDescriptor<PersistentStimulusState>(
            predicate: #Predicate { $0.stimulusID == stimulusID }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func ensurePersistentState(stimulusID: UUID) throws -> PersistentStimulusState {
        if let existing = try fetchPersistentState(stimulusID: stimulusID) {
            return existing
        }

        let state = PersistentStimulusState(stimulusID: stimulusID)
        modelContext.insert(state)
        return state
    }
}
