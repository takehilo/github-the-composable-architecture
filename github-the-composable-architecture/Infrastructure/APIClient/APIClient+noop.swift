#if DEBUG
import Foundation
import APIKit

class NoopSessionTask: SessionTask {
    func resume() {}
    func cancel() {}
}

class NoopSessionAdapter: SessionAdapter {
    func createTask(
        with URLRequest: URLRequest,
        handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> SessionTask {
        return NoopSessionTask()
    }

    func getTasks(with handler: @escaping ([SessionTask]) -> Void) {
        handler([])
    }
}

extension APIClient {
    /// プレビューおよびテスト時のモック用APIClientインスタンスを生成します
    static let noop: APIClient = {
        let adapter = NoopSessionAdapter()
        let session = Session(adapter: adapter)
        return APIClient(session: session, authTokenProvider: nil)
    }()
}
#endif
