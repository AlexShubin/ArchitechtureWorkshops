struct ScoreHistoryViewState: Equatable {
    let activities: [Activity]

    struct Activity: Identifiable, Equatable {
        let id: UUID
        let time: String
        let rightAnswers: Int
        let wrongAnswers: Int
    }
}

struct ScoreHistoryViewStateConverter {
    let convert: (ModuleState) -> ScoreHistoryViewState

    static func make(dateFormatter: ModuleDateFormatter) -> ScoreHistoryViewStateConverter {
        ScoreHistoryViewStateConverter {
            ScoreHistoryViewState(activities: $0.scoreHistory.activities.map {
                ScoreHistoryViewState.Activity(id: $0.id,
                                               time: dateFormatter.format($0.timestamp),
                                               rightAnswers: $0.results.rightAnswers,
                                               wrongAnswers: $0.results.wrongAnswers)
            })
        }
    }

    static let live = ScoreHistoryViewStateConverter.make(dateFormatter: ModuleDateFormatter.medium)
}
