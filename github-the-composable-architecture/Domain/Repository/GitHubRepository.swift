import Combine

protocol GitHubRepository {
    func searchRepositories(query: String) -> AnyPublisher<SearchRepoResultDto, APIError>
}
