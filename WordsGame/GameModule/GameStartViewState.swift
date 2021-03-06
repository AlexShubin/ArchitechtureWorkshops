import CoreModels

struct GameStartViewState: Equatable {
    let isGameStarted: Bool
    let latestActivity: Activity?

    struct Activity: Equatable {
        let rightAnswers: Int
        let wrongAnswers: Int
    }
}

struct GameStartViewStateConverter {
    let convert: (ModuleState) -> GameStartViewState

    static let live = Self { moduleState in
        .init(
            isGameStarted: moduleState.isGameStarted,
            latestActivity: moduleState.scoreHistory.activities
                .first
                .map(GameStartViewState.Activity.init)
        )
    }
}

private extension GameStartViewState.Activity {
    init(from scoreHistoryActivity: ScoreHistory.Activity) {
        self.init(rightAnswers: scoreHistoryActivity.results.rightAnswers,
                  wrongAnswers: scoreHistoryActivity.results.wrongAnswers)
    }
}
