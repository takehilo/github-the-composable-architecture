import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppCore.State, AppCore.Action>
    @ObservedObject private var viewStore: ViewStore<AppCore.ViewState, AppCore.Action>

    init(store: Store<AppCore.State, AppCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: \.viewState))
    }

    var body: some View {
        RankedSearchRepositoriesView(
            store: store.scope(
                state: \.rankedSearchRepositories,
                action: AppCore.Action.rankedSearchRepositories))
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static func store() -> Store<AppCore.State, AppCore.Action> {
        .init(
            initialState: .init(),
            reducer: AppCore.reducer,
            environment: .noop
        )
    }

    static var previews: some View {
        Group {
            AppView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif

