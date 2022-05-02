import SwiftUI
import ComposableArchitecture
import Kingfisher

struct GoldItemView: View {
    let store: Store<GoldItemCore.State, GoldItemCore.Action>
    @ObservedObject private var viewStore: ViewStore<GoldItemCore.ViewState, GoldItemCore.Action>

    init(store: Store<GoldItemCore.State, GoldItemCore.Action>) {
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
    }
}

#if DEBUG
struct GoldItemView_Previews: PreviewProvider {
    static func store() -> Store<GoldItemCore.State, GoldItemCore.Action> {
        .init(
            initialState: .init(id: 1, viewState: .init(
                name: "takehilo/github-the-composable-architecture",
                description: "The Composable Architecture sample using GitHub API",
                stars: 100)),
            reducer: GoldItemCore.reducer,
            environment: .init()
        )
    }

    static var previews: some View {
        Group {
            GoldItemView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif

