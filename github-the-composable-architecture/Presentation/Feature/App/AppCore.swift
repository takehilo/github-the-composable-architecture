import ComposableArchitecture

enum AppCore {}

// MARK: - State
extension AppCore {
    struct State: Equatable {
        var searchRepositories = SearchRepositoriesCore.State()
        var rankedSearchRepositories = RankedSearchRepositoriesCore.State()
        let viewState = ViewState()
    }
}

// MARK: - ViewState
extension AppCore {
    struct ViewState: Equatable {
    }
}

// MARK: - Action
extension AppCore {
    enum Action: Equatable {
        case searchRepositories(SearchRepositoriesCore.Action)
        case rankedSearchRepositories(RankedSearchRepositoriesCore.Action)
    }
}

// MARK: - Environment
extension AppCore {
    struct Environment {
        let scheduler: AnySchedulerOf<DispatchQueue>
        let gitHubRepository: GitHubRepository
    }
}

// MARK: - Reducer
extension AppCore {
    static let reducer = Reducer<State, Action, Environment>.combine(
        SearchRepositoriesCore.reducer
            .pullback(
                state: \.searchRepositories,
                action: /Action.searchRepositories,
                environment: {
                    .init(
                        scheduler: $0.scheduler,
                        gitHubRepository: $0.gitHubRepository
                    )
                }),
        RankedSearchRepositoriesCore.reducer
            .pullback(
                state: \.rankedSearchRepositories,
                action: /Action.rankedSearchRepositories,
                environment: {
                    .init(
                        scheduler: $0.scheduler,
                        gitHubRepository: $0.gitHubRepository
                    )
                })
    )
}

extension AppCore.Environment {
    static let live: AppCore.Environment = Self(
        scheduler: DispatchQueue.main.eraseToAnyScheduler(),
        gitHubRepository: GitHubRepositoryImpl()
    )

    #if DEBUG
    static let noop: AppCore.Environment = Self(
        scheduler: DispatchQueue.main.eraseToAnyScheduler(),
        gitHubRepository: GitHubRepositoryImpl(apiClient: .noop)
    )
    #endif
}

var appStore = Store(
    initialState: AppCore.State(),
    reducer: AppCore.reducer,
    environment: .live
)
