import AVFoundation
import Foundation
import Observation

@MainActor
protocol VoiceCaptureService: AnyObject {
    var isRecording: Bool { get }
    var isPaused: Bool { get }
    var elapsedTime: TimeInterval { get }
    var currentAttachment: VoiceAttachment? { get }
    func requestPermission() async -> Bool
    func startRecording() async throws
    func togglePause() throws
    func finishRecording(transcription: String?) throws -> VoiceAttachment?
    func discardRecording()
}

@Observable
@MainActor
final class DefaultVoiceCaptureService: NSObject, VoiceCaptureService, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var recordingStartDate: Date?
    private var currentFileURL: URL?

    var isRecording = false
    var isPaused = false
    var elapsedTime: TimeInterval = 0
    var currentAttachment: VoiceAttachment?

    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    func startRecording() async throws {
        let granted = await requestPermission()
        guard granted else {
            throw NSError(domain: "VoiceCapture", code: 1, userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied"])
        }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try session.setActive(true)

        let fileURL = try FileStorage.makeFileURL(prefix: "voice", pathExtension: "m4a")
        currentFileURL = fileURL
        let recorder = try AVAudioRecorder(
            url: fileURL,
            settings: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                AVNumberOfChannelsKey: 1
            ]
        )
        recorder.delegate = self
        recorder.record()
        audioRecorder = recorder
        recordingStartDate = .now
        isRecording = true
        isPaused = false
        elapsedTime = 0
        currentAttachment = nil
        startTimer()
    }

    func togglePause() throws {
        guard let recorder = audioRecorder else { return }
        if isPaused {
            recorder.record()
            isPaused = false
            recordingStartDate = .now.addingTimeInterval(-elapsedTime)
            startTimer()
        } else {
            recorder.pause()
            isPaused = true
            stopTimer()
        }
    }

    func finishRecording(transcription: String?) throws -> VoiceAttachment? {
        guard let recorder = audioRecorder, let currentFileURL else { return currentAttachment }
        recorder.stop()
        stopTimer()
        let duration = elapsedTime
        let attachment = VoiceAttachment(
            filePath: currentFileURL.path(),
            duration: duration,
            transcription: transcription
        )
        currentAttachment = attachment
        isRecording = false
        isPaused = false
        audioRecorder = nil
        self.currentFileURL = nil
        return attachment
    }

    func discardRecording() {
        stopTimer()
        isRecording = false
        isPaused = false
        audioRecorder?.stop()
        if let currentFileURL {
            try? FileManager.default.removeItem(at: currentFileURL)
        }
        audioRecorder = nil
        currentFileURL = nil
        recordingStartDate = nil
        elapsedTime = 0
        currentAttachment = nil
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self, let recordingStartDate else { return }
            self.elapsedTime = max(0, Date().timeIntervalSince(recordingStartDate))
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
