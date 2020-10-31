import SwiftUI
import GameModule
import ScoreHistoryModule

struct TabBarView: View {
    let store: AppStore

    var body: some View {
        TabView {
            GameStartView(store: store.scope(state: { $0.gameModuleState },
                                             action: { .gameModule($0) }))
                .tabItem {
                    Image.game
                    Text("Game")
            }
            ScoreHistoryView(store: store.scope(state: { $0.scoreHistoryModuleState },
                                                action: { .scoreHistoryModule($0) }))
                .tabItem {
                    Image.list
                    Text("Score")
            }
        }
    }
}

private extension Image {
    static let game = Image(systemName: "gamecontroller.fill")
    static let list = Image(systemName: "list.dash")
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(store: AppStore(initialState: AppState(), reducer: reducer, environment: .live))
    }
}
