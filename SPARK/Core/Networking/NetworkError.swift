import Foundation

enum NetworkError: LocalizedError {
    case missingBaseURL
    case invalidURL
    case invalidResponse
    case statusCode(Int)

    var errorDescription: String? {
        switch self {
        case .missingBaseURL:
            return "No backend is configured."
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The backend response is invalid."
        case .statusCode(let code):
            return "The backend returned status code \(code)."
        }
    }
}
