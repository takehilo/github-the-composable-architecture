import ComposableArchitecture

enum PlatinumItemCore {}

// MARK: - State
extension PlatinumItemCore {
    struct State: Equatable, Identifiable {
        let id: Int
        let viewState: ViewState
    }
}

// MARK: - ViewState
extension PlatinumItemCore {
    struct ViewState: Equatable {
        let name: String
        let description: String?
        let stars: Int
        let image = URL(string: "https://picsum.photos/id/\(Int.random(in: 0...100))/300/200")!
    }
}

// MARK: - Action
extension PlatinumItemCore {
    enum Action: Equatable {
    }
}

// MARK: - Environment
extension PlatinumItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension PlatinumItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == PlatinumItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [PlatinumItemCore.State] = dto.items.map {
            .init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount))
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
