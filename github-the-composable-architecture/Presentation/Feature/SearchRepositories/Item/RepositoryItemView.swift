import SwiftUI
import ComposableArchitecture
import Kingfisher

struct RepositoryItemView: View {
    let store: Store<RepositoryItemCore.State, RepositoryItemCore.Action>
    @ObservedObject private var viewStore: ViewStore<RepositoryItemCore.ViewState, RepositoryItemCore.Action>

    init(store: Store<RepositoryItemCore.State, RepositoryItemCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: \.viewState))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFAnimatedImage(viewStore.image)
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 100)
            Text(viewStore.name)
                .font(.title)
            Text(viewStore.description ?? "")
                .font(.body)
            HStack {
                Image(systemName: "star.fill")
                Text(viewStore.stars.description)
            }
        }
        .padding(8)
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

#if DEBUG
struct RepositoryItemView_Previews: PreviewProvider {
    static func store() -> Store<RepositoryItemCore.State, RepositoryItemCore.Action> {
        .init(
            initialState: .init(id: 1, viewState: .init(
                name: "takehilo/github-the-composable-architecture",
                description: "The Composable Architecture sample using GitHub API",
                stars: 100)),
            reducer: RepositoryItemCore.reducer,
            environment: .init()
        )
    }

    static var previews: some View {
        Group {
            RepositoryItemView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif

