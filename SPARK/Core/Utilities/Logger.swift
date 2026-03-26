import Foundation
import OSLog

enum Logger {
    static let subsystem = "yehosuahercules.SPARK"
    static let app = OSLog(subsystem: subsystem, category: "app")
    static let persistence = OSLog(subsystem: subsystem, category: "persistence")
    static let networking = OSLog(subsystem: subsystem, category: "networking")
}
