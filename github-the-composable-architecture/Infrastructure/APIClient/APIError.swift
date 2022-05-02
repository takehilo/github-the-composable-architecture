import Foundation

enum APIError: Error, Equatable {
    case unacceptableStatusCode(Int, NSError)
    case unknown(NSError)
}
