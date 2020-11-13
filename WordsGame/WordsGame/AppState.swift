import CoreModels
import GameModule
import ScoreHistoryModule
import ComposableArchitecture

typealias AppStore = Store<AppState, AppAction>

struct AppState {
    var gameData = GameDataState.loading
    var gameResults = GameResults.empty
    var roundNumber = 0
    var isGameStarted = false
    var scoreHistory = ScoreHistory.empty
    
    var gameModuleState: GameModule.ModuleState {
        get {
            GameModule.ModuleState(gameData: gameData,
                                   gameResults: gameResults,
                                   roundNumber: roundNumber,
                                   isGameStarted: isGameStarted,
                                   scoreHistory: scoreHistory)
        }
        set {
            gameData = newValue.gameData
            gameResults = newValue.gameResults
            roundNumber = newValue.roundNumber
            isGameStarted = newValue.isGameStarted
            scoreHistory = newValue.scoreHistory
        }
    }
    
    var scoreHistoryModuleState: ScoreHistoryModule.ModuleState {
        get {
            ScoreHistoryModule.ModuleState(scoreHistory: scoreHistory)
        }
        set {
            scoreHistory = newValue.scoreHistory
        }
    }
}

enum AppAction {
    case scoreHistoryModule(ScoreHistoryModule.ModuleAction)
    case gameModule(GameModule.ModuleAction)
}

let reducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    GameModule.reducer.pullback(state: \.gameModuleState,
                                action: /AppAction.gameModule,
                                environment: { $0.gameModule }),
    ScoreHistoryModule.reducer.pullback(state: \.scoreHistoryModuleState,
                                        action: /AppAction.scoreHistoryModule,
                                        environment: { _ in })
)

