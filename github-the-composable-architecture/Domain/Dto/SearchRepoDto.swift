import Foundation

struct SearchRepoResultDto: Decodable, Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [SearchRepoDto]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct SearchRepoDto: Decodable, Equatable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
    }
}
