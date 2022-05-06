import Combine

protocol GitHubRepository {
    func searchRepositories(query: String, page: Int) -> AnyPublisher<SearchRepoResultDto, APIError>
}
