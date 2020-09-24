import CoreModels

struct AppState {
    var gameData = GameData.default
    var gameResults = GameResults.empty
    var roundNumber = 0
    var isGameStarted = false
    var scoreHistory = ScoreHistory.empty
}

enum AppAction {
    case answer(isCorrect: Bool)
    case startGame
    case stopGame
    case removeActivities(indexSet: IndexSet)
}

func reducer(state: inout AppState, action: AppAction) -> Void {
    switch action {
    case .answer(let isCorrect):
        let isTranslationCorrect = state.gameData.rounds[state.roundNumber].isTranslationCorrect
        if isCorrect == isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber >= state.gameData.rounds.count - 1 {
            state.isGameStarted = false
            state.scoreHistory.activities.append(.init(id: UUID(),
                                                       timestamp: Date(),
                                                       results: state.gameResults))
        } else  {
            state.roundNumber += 1
        }
    case .startGame:
        state.roundNumber = 0
        state.gameResults = .empty
        state.isGameStarted = true
    case .stopGame:
        state.isGameStarted = false
    case .removeActivities(let indexSet):
        state.scoreHistory.activities.remove(at: indexSet)
    }
}

extension Array {
    mutating func remove(at indexes: IndexSet) {
        var enumerated = Swift.Array(self.enumerated())
        enumerated.removeAll { indexes.contains($0.offset) }
        self = enumerated.map { $0.element }
    }
}


typealias AppStore = Store<AppState, AppAction>


