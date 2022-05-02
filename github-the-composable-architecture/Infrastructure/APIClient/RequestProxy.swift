import Foundation
import APIKit

protocol RequestProxy: APIKit.Request where Self.Response == Request.Response {
    associatedtype Request: APIKit.Request
    var request: Request { get }
}

extension RequestProxy {
    var baseURL: URL { request.baseURL }
    var method: APIKit.HTTPMethod { request.method }
    var path: String { request.path }
    var parameters: Any? { request.parameters }
    var queryParameters: [String: Any]? { request.queryParameters }
    var bodyParameters: BodyParameters? { request.bodyParameters }
    var headerFields: [String: String] { request.headerFields }
    var dataParser: DataParser { request.dataParser }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        try request.intercept(urlRequest: urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        try request.intercept(object: object, urlResponse: urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        try request.response(from: object, urlResponse: urlResponse)
    }
}

struct AuthorizedRequestProxy<R: Request>: RequestProxy {
    typealias Request = R
    typealias Response = R.Response
    let request: R
    let authTokenProvider: AuthTokenProvider?

    var headerFields: [String: String] {
        guard let authTokenProvider = authTokenProvider else { return request.headerFields }
        var headers = request.headerFields
        headers["Authorization"] = authTokenProvider()
        return headers
   }
}
