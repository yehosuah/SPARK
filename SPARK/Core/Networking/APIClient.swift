import Foundation

protocol APIClient: AnyObject {
    func request<T: Decodable>(_ endpoint: Endpoint, decode type: T.Type) async throws -> T
}

final class DefaultAPIClient: APIClient {
    private let environment: AppEnvironment
    private let session: URLSession

    init(environment: AppEnvironment, session: URLSession = .shared) {
        self.environment = environment
        self.session = session
    }

    func request<T>(_ endpoint: Endpoint, decode type: T.Type) async throws -> T where T: Decodable {
        guard let baseURL = environment.apiBaseURL else {
            throw NetworkError.missingBaseURL
        }

        let request = try RequestBuilder.buildRequest(baseURL: baseURL, endpoint: endpoint)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
