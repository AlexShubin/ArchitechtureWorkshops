import SwiftUI
import CoreModels

struct ContentView: View {
    @State var gameData = GameData.default
    @State var gameResults = GameResults.empty
    @State var roundNumber = 0

    var body: some View {
        VStack(spacing: 20) {
            Text(gameData.rounds[roundNumber].questionWord)
            Text(gameData.rounds[roundNumber].answerWord)
            HStack(spacing: 20) {
                Button(action: { self.answer(isCorrect: true) },
                       label: { Text("YAY 🤗") })
                Button(action: { self.answer(isCorrect: false) },
                       label: { Text("NAY 😡") })
            }
            Text("Correct answers: \(gameResults.rightAnswers)")
            Text("Wrong answers: \(gameResults.wrongAnswers)")
        }.font(.title)
    }

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
