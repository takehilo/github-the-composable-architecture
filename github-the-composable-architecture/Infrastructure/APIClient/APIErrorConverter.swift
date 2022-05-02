import APIKit
import Foundation

struct APIErrorConverter {
    static func convert(_ originalError: SessionTaskError) -> APIError {
        switch originalError {
        case let .connectionError(error), let .responseError(error), let .requestError(error):
            return .unknown(error as NSError)
        case let .responseError(error as APIError):
            return error
        }
    }

    static func convert(object: Any, urlResponse: HTTPURLResponse) -> APIError {
        let nsError = NSError(
            domain: "APIError",
            code: urlResponse.statusCode,
            userInfo: object as? [String: Any] ?? [:]
        )

        return .unacceptableStatusCode(urlResponse.statusCode, nsError)
    }
}
