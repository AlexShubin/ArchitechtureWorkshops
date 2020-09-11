import SwiftUI

struct GameStartView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        VStack(spacing: 20) {
            Button(action: { self.store.send(.startGame) },
                   label: { Text("Start game") })
                .font(.largeTitle)
            self.results
        }
        .sheet(isPresented: Binding.constant(store.state.isGameStarted),
               onDismiss: { self.store.send(.stopGame) },
               content: { GameView(store: self.store) })
    }

    private var results: AnyView {
        guard let gameResults = store.state.scoreHistory.activities.first?.results else {
            return AnyView(EmptyView())
        }
        return AnyView(
            VStack(spacing: 10) {
                Text("Your latest result: ")
                    .font(.title)
                Text("Correct answer: \(gameResults.rightAnswers)")
                    .font(.headline)
                Text("Wrong answers: \(gameResults.wrongAnswers)")
                    .font(.headline)
            }
        )
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1))
        ]
        return GameStartView(store: AppStore(initialState: state, reducer: reducer))
    }
}
