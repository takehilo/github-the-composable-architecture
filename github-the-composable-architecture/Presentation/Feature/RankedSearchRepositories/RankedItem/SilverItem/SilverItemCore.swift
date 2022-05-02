import ComposableArchitecture

enum SilverItemCore {}

// MARK: - State
extension SilverItemCore {
    struct State: Equatable, Identifiable {
        let id: Int
        let viewState: ViewState
    }
}

// MARK: - ViewState
extension SilverItemCore {
    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int
        let image = URL(string: "https://picsum.photos/id/\(Int.random(in: 0...100))/300/200")!
    }
}

// MARK: - Action
extension SilverItemCore {
    enum Action: Equatable {
    }
}

// MARK: - Environment
extension SilverItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension SilverItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == SilverItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [SilverItemCore.State] = dto.items.map {
            .init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount))
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
