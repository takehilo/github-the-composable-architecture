import SwiftUI
import ComposableArchitecture

struct RankedItemView: View {
    let store: Store<RankedItemCore.State, RankedItemCore.Action>
    @ObservedObject private var viewStore: ViewStore<Void, RankedItemCore.Action>

    init(store: Store<RankedItemCore.State, RankedItemCore.Action>) {
        self.store = store
        self.viewStore = ViewStore(store.stateless)
    }

    var body: some View {
        SwitchStore(store) {
            CaseLet(
                state: /RankedItemCore.State.bronze,
                action: RankedItemCore.Action.bronze
            ) {
                BronzeItemView(store: $0)
            }
            CaseLet(
                state: /RankedItemCore.State.silver,
                action: RankedItemCore.Action.silver
            ) {
                SilverItemView(store: $0)
            }
            CaseLet(
                state: /RankedItemCore.State.gold,
                action: RankedItemCore.Action.gold
            ) {
                GoldItemView(store: $0)
            }
            CaseLet(
                state: /RankedItemCore.State.platinum,
                action: RankedItemCore.Action.platinum
            ) {
                PlatinumItemView(store: $0)
            }
            CaseLet(
                state: /RankedItemCore.State.diamond,
                action: RankedItemCore.Action.diamond
            ) {
                DiamondItemView(store: $0)
            }
            Default {
                EmptyView()
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}
