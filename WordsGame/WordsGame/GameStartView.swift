import SwiftUI

struct GameStartView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        Button(action: { self.store.send(.startGame) },
               label: { Text("Start game") })
            .font(.largeTitle)
            .sheet(isPresented: Binding.constant(store.state.isGameStarted),
                   onDismiss: { self.store.send(.stopGame) },
                   content: { GameView(store: self.store) })
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(store: AppStore(initialState: AppState(), reducer: reducer))
    }
}
