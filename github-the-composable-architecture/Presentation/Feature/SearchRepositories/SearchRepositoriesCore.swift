import ComposableArchitecture

enum SearchRepositoriesCore {}

// MARK: - State
extension SearchRepositoriesCore {
    struct State: Equatable {
        var viewState = ViewState()
        var repositoryItems = IdentifiedArrayOf<RepositoryItemCore.State>()
    }
}

struct Repo: Identifiable, Equatable {
    let id: Int
    let name: String
    let stars: Int
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
            case let .queryChanged(query):
                state.viewState.query = query
                return env.gitHubRepository
                    .searchRepositories(query: query)
//                    .debounce(for: 0.5, scheduler: env.scheduler)
                    .catchToEffect(Action.searchRepositoriesResult)
            case let .searchRepositoriesResult(.success(dto)):
                state.repositoryItems = .init(dto: dto)
                return .none
            case let .searchRepositoriesResult(.failure(error)):
                print(error)
                return .none
            }
        }
    )
}
