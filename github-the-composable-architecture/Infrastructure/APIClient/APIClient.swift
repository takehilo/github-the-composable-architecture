import Foundation
import APIKit
import Combine

typealias AuthTokenProvider = () -> String?

final class APIClient {
    private let session: Session
    private let callbackQueue: CallbackQueue
    private let authTokenProvider: AuthTokenProvider?

    init(
        session: Session = .shared,
        callbackQueue: CallbackQueue = .main,
        authTokenProvider: AuthTokenProvider?
    ) {
        self.session = session
        self.callbackQueue = callbackQueue
        self.authTokenProvider = authTokenProvider
    }

    func send<T: BaseRequest>(request: T) -> AnyPublisher<T.Response, APIError> {
        let req = AuthorizedRequestProxy(request: request, authTokenProvider: authTokenProvider)
        return session.sessionTaskPublisher(for: req, callbackQueue: callbackQueue)
            .mapError { APIErrorConverter.convert($0) }
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    static let live = APIClient(
        authTokenProvider: {
            let user = "Your GitHub Username"
            let token = "Personal Access Token"
            let encodedToken = "\(user):\(token)".data(using: .utf8)!.base64EncodedString()
            return "Basic \(encodedToken)"
        }
    )
}
