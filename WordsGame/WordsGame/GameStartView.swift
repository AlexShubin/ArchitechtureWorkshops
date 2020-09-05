import SwiftUI

struct GameStartView: View {
    @ObservedObject var store: AppStore

    init(store: AppStore) {
        self.store = store
    }

    var body: some View {
        Button(action: { self.store.startGame() },
               label: { Text("Start game") })
            .font(.largeTitle)
            .sheet(isPresented: Binding.constant(store.state.gameStarted),
                   onDismiss: { self.store.finishGame() },
                   content: { GameView(store: self.store) })
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(store: AppStore(initialState: AppState()))
    }
}
