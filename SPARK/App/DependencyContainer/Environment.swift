import Foundation

struct AppEnvironment {
    let apiBaseURL: URL?
    let shouldUseSeedData: Bool
    let enableRemoteFallbacks: Bool

    static let live = AppEnvironment(
        apiBaseURL: nil,
        shouldUseSeedData: true,
        enableRemoteFallbacks: true
    )

    static let preview = AppEnvironment(
        apiBaseURL: nil,
        shouldUseSeedData: true,
        enableRemoteFallbacks: false
    )
}
