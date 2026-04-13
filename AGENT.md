# AGENT.md

## Project Summary

SPARK is a native SwiftUI iOS app for creative discovery, quick capture, and idea development. The actual git root is this `SPARK/` directory; the sibling files one level up (`../SPARK_overview.md` and `../SPARK_product_spec.md`) are product-context docs, while the Xcode project, source, and tests live here.

## Repository Map

- `README.md`: quick setup, product summary, and the baseline test command.
- `SPARK/`: app source.
  - `App/`: app entrypoint, dependency injection, navigation, and theme tokens.
  - `Core/`: domain models, repositories, services, networking, SwiftData persistence, and utilities.
  - `Features/`: feature views/view models for Home, Discover, Capture, Library, Idea Detail, Onboarding, and shared UI.
  - `Resources/SampleData/`: seeded JSON used by local stimulus/onboarding flows and fallback behavior.
- `SPARKTests/`: unit tests using Swift's `Testing` framework plus mocks and `TestSupport.swift`.
- `SPARKUITests/`: minimal template UI tests using `XCTest`.
- `SPARK.xcodeproj/`: single project with one scheme, `SPARK`.
- `build/`: generated local output currently present as an untracked directory; do not edit or commit it.

## Commands

Run commands from the repo root (`/Users/yehosuahercules/Desktop/Misc./Spark/SPARK`).

- Open in Xcode: `open SPARK.xcodeproj`
- List available simulators/destinations: `xcodebuild -showdestinations -project SPARK.xcodeproj -scheme SPARK`
- Build the app for simulator: `xcodebuild build -project SPARK.xcodeproj -scheme SPARK -destination 'platform=iOS Simulator,name=iPhone 17'`
- Run the full test suite: `xcodebuild test -project SPARK.xcodeproj -scheme SPARK -destination 'platform=iOS Simulator,name=iPhone 17'`
- Run one test target/group: `xcodebuild test -project SPARK.xcodeproj -scheme SPARK -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:SPARKTests/HomeViewModelTests`

Notes:

- The project deployment target is `iOS 26.2`; use an Xcode version with the iPhone Simulator 26.2 SDK or newer.
- If a named simulator destination stalls, re-run with a booted simulator ID from `xcodebuild -showdestinations` or `xcrun simctl list devices`.
- No `Makefile`, `Package.swift`, `swiftlint`, or `swiftformat` config is present. Build + tests are the real validation surface.

## Conventions

- Dependency injection flows through `SPARK/App/DependencyContainer/AppContainer.swift` and `ServiceRegistry.swift`. New services/repositories should usually be wired there and consumed via feature view models.
- View models and several services use `@Observable` and `@MainActor`; follow the existing concurrency/isolation style unless there is a strong reason to change it.
- Persistence uses SwiftData models under `SPARK/Core/Persistence/SwiftData/` plus mappers under `SPARK/Core/Persistence/Mapping/`. If you change persisted/domain shape, update persistent models, mappers, repositories, and tests together.
- Repository protocols live in `SPARK/Core/Repositories/`; concrete implementations are mostly `SwiftData*` or `UserDefaults*`.
- Seeded local content is intentional. `AppEnvironment.live.apiBaseURL` is `nil`, so `DefaultAPIClient` throws on remote requests and `DefaultStimulusFeedService` falls back to seeded sample data for Discover.
- Development actions also have intentional fallback behavior: if AI generation fails, `DefaultDevelopmentActionService` returns local canned suggestions.
- Voice and sketch capture write files via `SPARK/Core/Utilities/FileStorage.swift` into Application Support. Changes to attachment models should account for on-disk file cleanup and migration behavior.

## Validation Before Handoff

- Minimum check after code edits: `xcodebuild build -project SPARK.xcodeproj -scheme SPARK -destination 'platform=iOS Simulator,name=iPhone 17'`
- For logic, repository, service, or view-model changes, also run the relevant `SPARKTests` coverage. Most unit tests build containers with `PersistenceController(inMemory: true)` via `SPARKTests/TestSupport.swift`.
- Treat `SPARKUITests/` as placeholder coverage unless you expand them; they currently contain the default template smoke tests only.
- If you change seed JSON, persistence, or capture flows, prefer a manual simulator run in addition to build/tests because resource loading, microphone permission, and file persistence are only lightly covered.

## Warnings and Guardrails

- The outer folder (`/Users/yehosuahercules/Desktop/Misc./Spark`) is not the git root. Do repo work from `/Users/yehosuahercules/Desktop/Misc./Spark/SPARK`.
- Product docs that explain intent live outside the repo root: `../SPARK_overview.md` and `../SPARK_product_spec.md`.
- `SPARK/Info.plist` includes `NSMicrophoneUsageDescription`; voice-capture work may require simulator/device permission resets while testing.
- `build/` is generated local output and is currently untracked. Leave it alone unless the user explicitly asks you to clean or inspect build artifacts.
