import CoreModels

struct AppState {
    var gameData = GameData.default
    var gameResults = GameResults.empty
    var roundNumber = 0
    var isGameStarted = false
}

final class AppStore: ObservableObject {
    @Published private(set) var state: AppState

    init(initialState: AppState) {
        self.state = initialState
    }

    func answer(isCorrect: Bool) {
        let isTranslationCorrect = state.gameData.rounds[state.roundNumber].isTranslationCorrect
        if isCorrect == isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber >= state.gameData.rounds.count - 1 {
            state.isGameStarted = false
        } else  {
            state.roundNumber += 1
        }
    }

    func startGame() {
        state.isGameStarted = true
    }

    func stopGame() {
        state.isGameStarted = false
    }
}
