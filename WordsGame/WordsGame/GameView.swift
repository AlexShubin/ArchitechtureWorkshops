import SwiftUI
import CoreModels

struct GameView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        switch store.state.gameData {
        case .loading:
            return AnyView(Text("Loading...").font(.title))
        case .failure:
            return failedBody
        case .loaded(let gameData):
            return loadedBody(gameData: gameData)
        }
    }

    private func loadedBody(gameData: GameData) -> AnyView {
        AnyView(
            VStack(spacing: 20) {
                Text(gameData.rounds[store.state.roundNumber].questionWord)
                Text(gameData.rounds[store.state.roundNumber].answerWord)
                HStack(spacing: 20) {
                    Button(action: { self.store.send(.answer(isCorrect: true)) },
                           label: { Text("YAY 🤗") })
                    Button(action: { self.store.send(.answer(isCorrect: false)) },
                           label: { Text("NAY 😡") })
                }
                Text("Correct answers: \(store.state.gameResults.rightAnswers)")
                Text("Wrong answers: \(store.state.gameResults.wrongAnswers)")
            }.font(.title)
        )
    }

    private var failedBody: AnyView {
        AnyView(
            VStack(spacing: 20) {
                Text("Oops! Something went wrong!")
                    .font(.subheadline)
                Button(action: { self.store.send(.startGame) },
                       label: { Text("Try again") })
                    .font(.title)
            }
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.gameData = .loading

        return GameView(store: AppStore(initialState: state, reducer: reducer, environment: .live))
    }
}
