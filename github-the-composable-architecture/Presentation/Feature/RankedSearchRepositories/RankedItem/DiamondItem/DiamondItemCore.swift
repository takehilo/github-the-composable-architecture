import ComposableArchitecture

enum DiamondItemCore {}

// MARK: - State
extension DiamondItemCore {
    struct State: Equatable, Identifiable {
        let id: Int
        let viewState: ViewState
    }
}

// MARK: - ViewState
extension DiamondItemCore {
    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int
        let image = URL(string: "https://picsum.photos/id/\(Int.random(in: 0...100))/300/200")!
    }
}

// MARK: - Action
extension DiamondItemCore {
    enum Action: Equatable {
    }
}

// MARK: - Environment
extension DiamondItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension DiamondItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == DiamondItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [DiamondItemCore.State] = dto.items.map {
            .init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount))
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
