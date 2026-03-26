import Foundation

@MainActor
protocol ResurfacingRepository: AnyObject {
    func isDismissed(key: String) -> Bool
    func dismiss(key: String)
    func reset(key: String)
}

@MainActor
final class UserDefaultsResurfacingRepository: ResurfacingRepository {
    private let userDefaults: UserDefaults
    private let keyPrefix = "spark.resurfacing.dismissed."

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func isDismissed(key: String) -> Bool {
        userDefaults.bool(forKey: keyPrefix + key)
    }

    func dismiss(key: String) {
        userDefaults.set(true, forKey: keyPrefix + key)
    }

    func reset(key: String) {
        userDefaults.removeObject(forKey: keyPrefix + key)
    }
}
