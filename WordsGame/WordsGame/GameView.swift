import SwiftUI
import CoreModels

struct GameView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        VStack(spacing: 20) {
            Text(store.state.gameData.rounds[store.state.roundNumber].questionWord)
            Text(store.state.gameData.rounds[store.state.roundNumber].answerWord)
            HStack(spacing: 20) {
                Button(action: { self.store.answer(isCorrect: true) },
                       label: { Text("YAY 🤗") })
                Button(action: { self.store.answer(isCorrect: false) },
                       label: { Text("NAY 😡") })
            }
            Text("Correct answers: \(store.state.gameResults.rightAnswers)")
            Text("Wrong answers: \(store.state.gameResults.wrongAnswers)")
        }.font(.title)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(store: AppStore(initialState: AppState()))
    }
}
