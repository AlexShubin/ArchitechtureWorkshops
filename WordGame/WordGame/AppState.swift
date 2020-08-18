import Common

class AppState: ObservableObject {
    @Published var gameData = GameData.default
    @Published var roundNumber = 0
    @Published var gameResults = GameResults.empty

    func answer(isCorrect: Bool) {
        let isTranslationCorrect = gameData.rounds[roundNumber].isTranslationCorrect
        if isCorrect == isTranslationCorrect {
            gameResults.rightAnswers += 1
        } else {
            gameResults.wrongAnswers += 1
        }
        roundNumber += 1
    }
}
