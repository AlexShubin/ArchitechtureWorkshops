import CoreModels
import ServiceKit
import ComposableArchitecture

public typealias ModuleEffect = Effect<ModuleAction, Never>
public typealias ModuleStore = Store<ModuleState, ModuleAction>

public struct ModuleState: Equatable {
    public var gameData = GameDataState.loading
    public var gameResults = GameResults.empty
    public var roundNumber = 0
    public var isGameStarted = false
    public var scoreHistory = ScoreHistory.empty

    public init(
        gameData: GameDataState = .loading,
        gameResults: GameResults = .empty,
        roundNumber: Int = 0,
        isGameStarted: Bool = false,
        scoreHistory: ScoreHistory = .empty
    ) {
        self.gameData = gameData
        self.gameResults = gameResults
        self.roundNumber = roundNumber
        self.isGameStarted = isGameStarted
        self.scoreHistory = scoreHistory
    }
}

public enum ModuleAction: Equatable {
    case answer(isCorrect: Bool)
    case startGame
    case stopGame
    case gameDataLoaded(GameData?)
}

public let reducer = Reducer<ModuleState, ModuleAction, ModuleEnvironment> { state, action, environment in
    switch action {
    case .answer(let isCorrect):
        guard let gameData = state.gameData.data else { return .none }

        let isTranslationCorrect = gameData.rounds[state.roundNumber].isTranslationCorrect
        if isCorrect == isTranslationCorrect {
            state.gameResults.rightAnswers += 1
        } else {
            state.gameResults.wrongAnswers += 1
        }
        if state.roundNumber >= gameData.rounds.count - 1 {
            state.isGameStarted = false
            state.scoreHistory.activities.insert(.init(id: environment.uuidProvider(),
                                                       timestamp: environment.dateProvider(),
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
        return environment.gameDataProvider.provide(10)
            .map(ModuleAction.gameDataLoaded)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .stopGame:
        state.isGameStarted = false
    case .gameDataLoaded(let gameData):
        state.gameData = gameData.map { .loaded($0) } ?? .failure
    }
    return .none
}

public enum GameDataState: Equatable {
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


