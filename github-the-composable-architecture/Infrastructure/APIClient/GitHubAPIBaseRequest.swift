import Foundation
import APIKit

protocol GitHubAPIBaseRequest: BaseRequest {
    var apiVersion: String? { get }
}

extension GitHubAPIBaseRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var headerFields: [String: String] { baseHeaders }
    var apiVersion: String? { nil }
    var decoder: JSONDecoder { JSONDecoder() }

    var baseHeaders: [String: String] {
        var params: [String: String] = [:]
        params["Accept"] = "application/vnd.github.v3+json"
        return params
    }
}
