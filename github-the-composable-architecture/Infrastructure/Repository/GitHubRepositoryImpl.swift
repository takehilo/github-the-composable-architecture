import Combine

final class GitHubRepositoryImpl {
    private let apiClient: APIClient

    init(
        apiClient: APIClient = .live
    ) {
        self.apiClient = apiClient
    }
}

extension GitHubRepositoryImpl: GitHubRepository {
    func searchRepositories(query: String) -> AnyPublisher<SearchRepoResultDto, APIError> {
        apiClient.send(request: SearchRepoRequest(query: query))
    }
}
