import SwiftUI
import ComposableArchitecture

struct SearchRepositoriesView: View {
    let store: Store<SearchRepositoriesCore.State, SearchRepositoriesCore.Action>
    @ObservedObject private var viewStore: ViewStore<SearchRepositoriesCore.ViewState, SearchRepositoriesCore.Action>

    init(store: Store<SearchRepositoriesCore.State, SearchRepositoriesCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: \.viewState))
    }

    var body: some View {
        NavigationView {
            List {
                ForEachStore(
                    store.scope(
                        state: \.repositoryItems,
                        action: SearchRepositoriesCore.Action.item(id:action:)),
                    content: RepositoryItemView.init(store:)
                )
            }
            .searchable(
                text: viewStore.binding(
                    get: \.query,
                    send: SearchRepositoriesCore.Action.queryChanged))
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

#if DEBUG
struct SearchRepositoriesView_Previews: PreviewProvider {
    static func store() -> Store<SearchRepositoriesCore.State, SearchRepositoriesCore.Action> {
        .init(
            initialState: .init(),
            reducer: SearchRepositoriesCore.reducer,
            environment: .noop
        )
    }

    static var previews: some View {
        Group {
            SearchRepositoriesView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
