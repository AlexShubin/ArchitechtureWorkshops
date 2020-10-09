import SwiftUI

struct GameStartView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        VStack(spacing: 10) {
            Button(action: { self.store.send(.startGame) },
                   label: { Text("Start game") })
                .font(.largeTitle)
                .sheet(isPresented: Binding.constant(store.state.isGameStarted),
                       onDismiss: { self.store.send(.stopGame) },
                       content: { GameView(store: self.store) })
            results
        }
    }

    private var results: AnyView {
        guard let gameResults = store.state.scoreHistory.activities.first?.results else {
            return AnyView(EmptyView())
        }
        return AnyView(
            VStack(spacing: 10) {
                Text("Your latest result: ")
                    .font(.title)
                Text("Correct answers: \(gameResults.rightAnswers)")
                Text("Wrong answers: \(gameResults.wrongAnswers)")
            }
            .font(.headline)
        )
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 10),
                  results: .init(rightAnswers: 2, wrongAnswers: 2))
        ]
        return GameStartView(store: AppStore(initialState: state, reducer: reducer, environment: .live))
    }
}
