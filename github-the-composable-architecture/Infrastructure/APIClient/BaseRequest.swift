import Foundation
import APIKit

protocol BaseRequest: Request where Response: Decodable {
    var decoder: JSONDecoder { get }
}

extension BaseRequest {
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw APIErrorConverter.convert(object: object, urlResponse: urlResponse)
        }
        return object
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try decoder.decode(Response.self, from: data)
    }
}
