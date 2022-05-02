import ComposableArchitecture

enum RankedSearchRepositoriesCore {}

// MARK: - State
extension RankedSearchRepositoriesCore {
    struct State: Equatable {
        var viewState = ViewState()
        var items = IdentifiedArrayOf<RankedItemCore.State>()
    }
}

// MARK: - ViewState
extension RankedSearchRepositoriesCore {
    struct ViewState: Equatable {
        var query = ""
    }
}

// MARK: - Action
extension RankedSearchRepositoriesCore {
    enum Action: Equatable {
        case onAppear
        case queryChanged(String)
        case searchRepositoriesResult(Result<SearchRepoResultDto, APIError>)
        case item(id: Int, action: RankedItemCore.Action)
    }
}

// MARK: - Environment
extension RankedSearchRepositoriesCore {
    struct Environment {
        let scheduler: AnySchedulerOf<DispatchQueue>
        let gitHubRepository: GitHubRepository
    }
}

extension RankedSearchRepositoriesCore.Environment {
    #if DEBUG
    static let noop: RankedSearchRepositoriesCore.Environment = Self(
        scheduler: DispatchQueue.main.eraseToAnyScheduler(),
        gitHubRepository: GitHubRepositoryImpl(apiClient: .noop)
    )
    #endif
}

// MARK: - Reducer
extension RankedSearchRepositoriesCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        .init { state, action, env in
            switch action {
            case .onAppear:
                return .init(value: .queryChanged("github"))
            case let .queryChanged(query):
                state.viewState.query = query
                return env.gitHubRepository
                    .searchRepositories(query: query)
                    .catchToEffect(Action.searchRepositoriesResult)
            case let .searchRepositoriesResult(.success(dto)):
                state.items = .init(dto: dto)
                return .none
            case let .searchRepositoriesResult(.failure(error)):
                print(error)
                return .none
            case .item:
                return .none
            }
        }
    )
}
