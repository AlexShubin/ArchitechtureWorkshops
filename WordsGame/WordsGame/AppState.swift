import CoreModels

struct AppState {
    var gameData = GameData.default
    var gameResults = GameResults.empty
    var roundNumber = 0
    var gameStarted = false
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
            state.gameStarted = false
        } else {
            state.roundNumber += 1
        }
    }

    func startGame() {
        state.gameStarted = true
        state.roundNumber = 0
        state.gameResults = .empty
    }

    func finishGame() {
        state.gameStarted = false
    }
}
