import Foundation

struct AIResponseParser {
    func parse(_ response: String) -> String {
        response.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
