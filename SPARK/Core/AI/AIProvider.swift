import Foundation

protocol AIProvider: AnyObject {
    func generate(prompt: String) async throws -> String
}

final class DefaultAIProvider: AIProvider {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func generate(prompt: String) async throws -> String {
        let data = try JSONEncoder().encode(["prompt": prompt])
        let endpoint = Endpoint(path: "ai/development-action", method: "POST", body: data)
        let response = try await apiClient.request(endpoint, decode: GeneratedPromptDTO.self)
        return response.content
    }
}
