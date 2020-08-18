//
//  ContentView.swift
//  WordGame
//
//  Created by ashubin on 18.08.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import SwiftUI
import Common

struct GameView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text(appState.gameData.rounds[appState.roundNumber].questionWord)
            Text(appState.gameData.rounds[appState.roundNumber].answerWord)
            HStack(spacing: 20) {
                Button(action: { self.appState.answer(isCorrect: true) },
                       label: { Text("YAY 🤗") })
                Button(action: { self.appState.answer(isCorrect: false) },
                       label: { Text("NAY 😡") })
            }
            Text("Correct answers: \(appState.gameResults.rightAnswers)")
            Text("Wrong answers: \(appState.gameResults.wrongAnswers)")
        }
        .font(.title)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(appState: AppState())
    }
}
