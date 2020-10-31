import XCTest
@testable import GameModule
import CoreModels
import Combine
import ComposableArchitecture

class GameModuleTests: XCTestCase {

    var environment: ModuleEnvironment!
    let scheduler = DispatchQueue.testScheduler
    
    override func setUp() {
        super.setUp()
        
        environment = .mock
        environment.mainQueue = scheduler.eraseToAnyScheduler()
    }

    func testGameHappyPath() {
        let testGameData = GameData(rounds: [
            .init(questionWord: "1", answerWord: "1t", isTranslationCorrect: true),
            .init(questionWord: "2", answerWord: "2t", isTranslationCorrect: true)
        ])
        let testDate = Date(timeIntervalSince1970: 10)
        
        environment.dateProvider = { testDate }
        
        environment.gameDataProvider.provide = { _ in
            Just(testGameData).eraseToAnyPublisher()
        }
        
        let testStore = TestStore(
            initialState: ModuleState(),
            reducer: reducer,
            environment: environment
        )
        
        testStore.assert(
            .send(.startGame) {
                $0.gameData = .loading
                $0.roundNumber = 0
                $0.gameResults = .empty
                $0.isGameStarted = true
            },
            .do { self.scheduler.advance() },
            .receive(.gameDataLoaded(testGameData)) {
                $0.gameData = .loaded(testGameData)
            },
            .send(.answer(isCorrect: true)) {
                $0.gameResults.rightAnswers = 1
                $0.roundNumber = 1
            },
            .send(.answer(isCorrect: false)) {
                $0.gameResults.wrongAnswers = 1
                $0.roundNumber = 1
                $0.scoreHistory = ScoreHistory(activities: [
                    .init(id: .fakeUUID,
                          timestamp: testDate,
                          results: .init(rightAnswers: 1, wrongAnswers: 1))
                ])
                $0.isGameStarted = false
            }
        )
    }

    func testGameUnhappyPath() {
        environment.gameDataProvider.provide = { _ in
            Just(nil).eraseToAnyPublisher()
        }

        let testStore = TestStore(
            initialState: ModuleState(),
            reducer: reducer,
            environment: environment
        )

        testStore.assert(
            .send(.startGame) {
                $0.gameData = .loading
                $0.roundNumber = 0
                $0.gameResults = .empty
                $0.isGameStarted = true
            },
            .do { self.scheduler.advance() },
            .receive(.gameDataLoaded(nil)) {
                $0.gameData = .failure
            }
        )
    }
}
