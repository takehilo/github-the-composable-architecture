import APIKit

struct SearchRepoRequest: GitHubAPIBaseRequest {
    typealias Response = SearchRepoResultDto
    let method = APIKit.HTTPMethod.get
    let path = "/search/repositories"
    let queryParameters: [String: Any]?

    init(
        query: String
    ) {
        self.queryParameters = ["q": query, "per_page": 100]
    }
}
