import Foundation

enum FileStorage {
    static func applicationSupportDirectory() throws -> URL {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let sparkDirectory = directory.appendingPathComponent("SPARK", isDirectory: true)
        if !FileManager.default.fileExists(atPath: sparkDirectory.path()) {
            try FileManager.default.createDirectory(at: sparkDirectory, withIntermediateDirectories: true)
        }
        return sparkDirectory
    }

    static func makeFileURL(prefix: String, pathExtension: String) throws -> URL {
        try applicationSupportDirectory()
            .appendingPathComponent("\(prefix)-\(UUID().uuidString)")
            .appendingPathExtension(pathExtension)
    }
}
