import APIKit

struct SearchRepoRequest: GitHubAPIBaseRequest {
    typealias Response = SearchRepoResultDto
    let method = APIKit.HTTPMethod.get
    let path = "/search/repositories"
    let queryParameters: [String: Any]?

    init(
        query: String,
        page: Int
    ) {
        self.queryParameters = [
            "q": query,
            "page": page.description,
            "per_page": 100
        ]
    }
}
