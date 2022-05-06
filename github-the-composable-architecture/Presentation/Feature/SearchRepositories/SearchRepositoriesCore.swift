import ComposableArchitecture

enum SearchRepositoriesCore {}

// MARK: - State
extension SearchRepositoriesCore {
    struct State: Equatable {
        var viewState = ViewState()
        var items = IdentifiedArrayOf<RepositoryItemCore.State>()
        var currentPage = 1
    }
}

// MARK: - ViewState
extension SearchRepositoriesCore {
    struct ViewState: Equatable {
        var query = ""
    }
}

// MARK: - Action
extension SearchRepositoriesCore {
    enum Action: Equatable {
        case onAppear
        case queryChanged(String)
        case searchRepositoriesResult(Result<SearchRepoResultDto, APIError>)
        case item(id: Int, action: RepositoryItemCore.Action)
    }
}

// MARK: - Environment
extension SearchRepositoriesCore {
    struct Environment {
        let scheduler: AnySchedulerOf<DispatchQueue>
        let gitHubRepository: GitHubRepository
    }
}

extension SearchRepositoriesCore.Environment {
    #if DEBUG
    static let noop: SearchRepositoriesCore.Environment = Self(
        scheduler: DispatchQueue.main.eraseToAnyScheduler(),
        gitHubRepository: GitHubRepositoryImpl(apiClient: .noop)
    )
    #endif
}

// MARK: - Reducer
extension SearchRepositoriesCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        .init { state, action, env in
            switch action {
            case .onAppear:
                return .init(value: .queryChanged("github"))
            case let .item(id: id, action: .onAppear):
                if id == state.items.last?.id {
                    return env.gitHubRepository
                        .searchRepositories(query: state.viewState.query, page: state.currentPage)
                        .catchToEffect(Action.searchRepositoriesResult)
                }
                return .none
            case let .queryChanged(query):
                state.viewState.query = query
                return env.gitHubRepository
                    .searchRepositories(query: query, page: state.currentPage)
                    .catchToEffect(Action.searchRepositoriesResult)
            case let .searchRepositoriesResult(.success(dto)):
                let items = IdentifiedArrayOf<RepositoryItemCore.State>(dto: dto)
                items.forEach { state.items.append($0) }
                state.currentPage += 1
                return .none
            case let .searchRepositoriesResult(.failure(error)):
                print(error)
                return .none
            }
        }
        .debug()
    )
}
