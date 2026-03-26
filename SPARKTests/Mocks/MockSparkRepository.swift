import Foundation
@testable import SPARK

@MainActor
final class MockStimulusRepository: StimulusRepository {
    var records: [StimulusRecord] = []

    func fetchAll() throws -> [StimulusRecord] { records }
    func fetchSaved() throws -> [StimulusRecord] { records.filter(\.isSaved) }
    func stimulus(id: UUID) throws -> Stimulus? { records.first { $0.id == id }?.stimulus }
    func record(id: UUID) throws -> StimulusRecord? { records.first { $0.id == id } }
    func upsert(_ stimulus: Stimulus) throws {
        if let index = records.firstIndex(where: { $0.id == stimulus.id }) {
            records[index].stimulus = stimulus
        } else {
            records.append(StimulusRecord(stimulus: stimulus, state: StimulusState(stimulusID: stimulus.id)))
        }
    }
    func upsert(contentsOf stimuli: [Stimulus]) throws {
        for stimulus in stimuli {
            try upsert(stimulus)
        }
    }
    func setSaved(_ isSaved: Bool, for stimulusID: UUID) throws {
        guard let index = records.firstIndex(where: { $0.id == stimulusID }) else { return }
        records[index].state.isSaved = isSaved
        records[index].state.savedAt = isSaved ? .now : nil
    }
    func setDismissed(_ isDismissed: Bool, for stimulusID: UUID) throws {
        guard let index = records.firstIndex(where: { $0.id == stimulusID }) else { return }
        records[index].state.isDismissed = isDismissed
    }
    func markViewed(_ stimulusID: UUID) throws {
        guard let index = records.firstIndex(where: { $0.id == stimulusID }) else { return }
        records[index].state.lastViewedAt = .now
    }
    func incrementResponseCount(for stimulusID: UUID) throws {
        guard let index = records.firstIndex(where: { $0.id == stimulusID }) else { return }
        records[index].state.responseCount += 1
    }
    func incrementBuildCount(for stimulusID: UUID) throws {
        guard let index = records.firstIndex(where: { $0.id == stimulusID }) else { return }
        records[index].state.buildCount += 1
    }
}
