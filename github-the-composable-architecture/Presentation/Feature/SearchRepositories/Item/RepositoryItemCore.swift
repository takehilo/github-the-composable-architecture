import ComposableArchitecture

enum RepositoryItemCore {}

// MARK: - State
extension RepositoryItemCore {
    struct State: Equatable, Identifiable {
        let id: Int
        let viewState: ViewState
    }
}

// MARK: - ViewState
extension RepositoryItemCore {
    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int
    }
}

// MARK: - Action
extension RepositoryItemCore {
    enum Action: Equatable {
    }
}

// MARK: - Environment
extension RepositoryItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension RepositoryItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == RepositoryItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [RepositoryItemCore.State] = dto.items.map {
            .init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount))
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
