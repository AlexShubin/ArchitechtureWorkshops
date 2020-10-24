import SwiftUI
import CoreModels
import ComposableArchitecture

struct GameView: View {
    let store: ModuleStore

    var body: some View {
        WithViewStore(store) { viewStore -> AnyView in
            switch viewStore.state.gameData {
            case .loading:
                return AnyView(Text("Loading...").font(.title))
            case .failure:
                return self.failedBody
            case .loaded(let gameData):
                return self.loadedBody(gameData: gameData)
            }
        }
    }

    private func loadedBody(gameData: GameData) -> AnyView {
        AnyView(
            WithViewStore(store) { viewStore in
                VStack(spacing: 20) {
                    Text(gameData.rounds[viewStore.state.roundNumber].questionWord)
                    Text(gameData.rounds[viewStore.state.roundNumber].answerWord)
                    HStack(spacing: 20) {
                        Button(action: { viewStore.send(.answer(isCorrect: true)) },
                               label: { Text("YAY 🤗") })
                        Button(action: { viewStore.send(.answer(isCorrect: false)) },
                               label: { Text("NAY 😡") })
                    }
                    Text("Correct answers: \(viewStore.state.gameResults.rightAnswers)")
                    Text("Wrong answers: \(viewStore.state.gameResults.wrongAnswers)")
                }.font(.title)
            }
        )
    }

    private var failedBody: AnyView {
        AnyView(
            WithViewStore(store) { viewStore in
                VStack(spacing: 20) {
                    Text("Oops! Something went wrong!")
                        .font(.subheadline)
                    Button(action: { viewStore.send(.startGame) },
                           label: { Text("Try again") })
                        .font(.title)
                }
            }
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.gameData = .loading

        return GameView(store: ModuleStore(initialState: state, reducer: reducer, environment: .live))
    }
}
