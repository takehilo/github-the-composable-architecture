import SwiftUI
import ComposableArchitecture
import Kingfisher

struct DiamondItemView: View {
    let store: Store<DiamondItemCore.State, DiamondItemCore.Action>
    @ObservedObject private var viewStore: ViewStore<DiamondItemCore.ViewState, DiamondItemCore.Action>

    init(store: Store<DiamondItemCore.State, DiamondItemCore.Action>) {
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
struct DiamondItemView_Previews: PreviewProvider {
    static func store() -> Store<DiamondItemCore.State, DiamondItemCore.Action> {
        .init(
            initialState: .init(id: 1, viewState: .init(
                name: "takehilo/github-the-composable-architecture",
                description: "The Composable Architecture sample using GitHub API",
                stars: 100)),
            reducer: DiamondItemCore.reducer,
            environment: .init()
        )
    }

    static var previews: some View {
        Group {
            DiamondItemView(store: store())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
