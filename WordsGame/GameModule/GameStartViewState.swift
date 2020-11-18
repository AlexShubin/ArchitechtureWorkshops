import CoreModels

struct GameStartViewState: Equatable {
    let isGameStarted: Bool
    let latestActivity: Activity?

    struct Activity: Identifiable, Equatable {
        let id: UUID
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
        self.init(id: scoreHistoryActivity.id,
                  rightAnswers: scoreHistoryActivity.results.rightAnswers,
                  wrongAnswers: scoreHistoryActivity.results.wrongAnswers)
    }
}
