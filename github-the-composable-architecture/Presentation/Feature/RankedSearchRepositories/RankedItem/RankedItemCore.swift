import ComposableArchitecture

enum RankedItemCore {}

// MARK: - State
extension RankedItemCore {
    enum State: Equatable, Identifiable {
        case bronze(BronzeItemCore.State)
        case silver(SilverItemCore.State)
        case gold(GoldItemCore.State)
        case platinum(PlatinumItemCore.State)
        case diamond(DiamondItemCore.State)

        var id: Int {
            switch self {
            case let .bronze(state): return state.id
            case let .silver(state): return state.id
            case let .gold(state): return state.id
            case let .platinum(state): return state.id
            case let .diamond(state): return state.id
            }
        }
    }
}

// MARK: - ViewState
extension RankedItemCore {
    struct ViewState: Equatable {
    }
}

// MARK: - Action
extension RankedItemCore {
    enum Action: Equatable {
        case bronze(BronzeItemCore.Action)
        case silver(SilverItemCore.Action)
        case gold(GoldItemCore.Action)
        case platinum(PlatinumItemCore.Action)
        case diamond(DiamondItemCore.Action)
        case onAppear
    }
}

// MARK: - Environment
extension RankedItemCore {
    struct Environment {
    }
}

// MARK: - Reducer
extension RankedItemCore {
    static let reducer = Reducer<State, Action, Environment>.empty
}

extension IdentifiedArrayOf
    where Element == RankedItemCore.State,
          ID == Int {

    init(
        dto: SearchRepoResultDto
    ) {
        let items: [RankedItemCore.State] = dto.items.map {
            switch $0.stargazersCount {
            case 0..<100:
                return .bronze(.init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount)))
            case 100..<500:
                return .silver(.init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount)))
            case 500..<1000:
                return .gold(.init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount)))
            case 1000..<3000:
                return .platinum(.init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount)))
            default:
                return .diamond(.init(id: $0.id, viewState: .init(name: $0.name, description: $0.description, stars: $0.stargazersCount)))
            }
        }
        self = IdentifiedArrayOf(uniqueElements: items)
    }
}
