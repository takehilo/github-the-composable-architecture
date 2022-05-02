import ComposableArchitecture

enum GoldItemCore {}

// MARK: - State
extension GoldItemCore {
    struct State: Equatable, Identifiable {
        let id: Int
        let viewState: ViewState
    }
}

// MARK: - ViewState
extension GoldItemCore {
    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int
        let image = URL(string: "https://picsum.photos/id/\(Int.random(in: 0...100))/300/200")!
    }
}

// MARK: - Action
extension GoldItemCore {
    enum Action: Equatable {
    }
}

// MARK: - Environment
extension GoldItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension GoldItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == GoldItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [GoldItemCore.State] = dto.items.map {
            .init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount))
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
