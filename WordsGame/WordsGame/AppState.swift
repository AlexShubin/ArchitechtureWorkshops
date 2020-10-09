import CoreModels
import ServiceKit

struct AppState {
    var gameData = GameDataState.loading
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
    case gameDataLoaded(GameData?)
}

func reducer(state: inout AppState, action: AppAction) -> Void {
    switch action {
    case .answer(let isCorrect):
        guard let gameData = state.gameData.data else { return }

        let isTranslationCorrect = gameData.rounds[state.roundNumber].isTranslationCorrect
        if isCorrect == isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber >= gameData.rounds.count - 1 {
            state.isGameStarted = false
            state.scoreHistory.activities.insert(.init(id: UUID(),
                                                       timestamp: Date(),
                                                       results: state.gameResults),
                                                 at: 0)
        } else  {
            state.roundNumber += 1
        }
    case .startGame:
        state.gameData = .loading
        state.roundNumber = 0
        state.gameResults = .empty
        state.isGameStarted = true
        reducer(state: &state, action: .gameDataLoaded(provide()))
    case .stopGame:
        state.isGameStarted = false
    case .removeActivities(let indexSet):
        state.scoreHistory.activities.remove(at: indexSet)
    case .gameDataLoaded(let gameData):
        state.gameData = gameData.map { .loaded($0) } ?? .failure
    }
}

///
import Combine
var cancellable: Cancellable?

func provide() -> GameData? {
    var data: GameData?
    let sync = DispatchSemaphore(value: 0)
    cancellable = GameDataProvider.live.provide(10)
        .sink {
            data = $0
            sync.signal()
    }
    sync.wait()
    return data
}
///

extension Array {
    mutating func remove(at indexes: IndexSet) {
        var enumerated = Swift.Array(self.enumerated())
        enumerated.removeAll { indexes.contains($0.offset) }
        self = enumerated.map { $0.element }
    }
}

typealias AppStore = Store<AppState, AppAction>

enum GameDataState: Equatable {
    case loading
    case failure
    case loaded(GameData)

    var data: GameData? {
        switch self {
        case .loaded(let data):
            return data
        default:
            return nil
        }
    }
}


