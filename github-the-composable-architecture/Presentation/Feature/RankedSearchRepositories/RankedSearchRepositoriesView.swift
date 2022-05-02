import SwiftUI
import ComposableArchitecture

struct RankedSearchRepositoriesView: View {
    let store: Store<RankedSearchRepositoriesCore.State, RankedSearchRepositoriesCore.Action>
    @ObservedObject private var viewStore: ViewStore<RankedSearchRepositoriesCore.ViewState, RankedSearchRepositoriesCore.Action>

    init(store: Store<RankedSearchRepositoriesCore.State, RankedSearchRepositoriesCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: \.viewState))
    }

    var body: some View {
        NavigationView {
            List {
                ForEachStore(
                    store.scope(
                        state: \.items,
                        action: RankedSearchRepositoriesCore.Action.item(id:action:)),
                    content: RankedItemView.init(store:)
                )
            }
            .searchable(
                text: viewStore.binding(
                    get: \.query,
                    send: RankedSearchRepositoriesCore.Action.queryChanged))
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

#if DEBUG
struct RankedSearchRepositoriesView_Previews: PreviewProvider {
    static func store() -> Store<RankedSearchRepositoriesCore.State, RankedSearchRepositoriesCore.Action> {
        .init(
            initialState: .init(),
            reducer: RankedSearchRepositoriesCore.reducer,
            environment: .noop
        )
    }

    static var previews: some View {
        Group {
            RankedSearchRepositoriesView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif

