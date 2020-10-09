import XCTest
@testable import ServiceKit
import Combine
import CoreModels

class GameDataProviderTests: XCTestCase {
    let sut = GameDataProvider.make(translatedWordsLoader: .mock,
                                    randomNumberGenerator: .mock)

    var cancellable: Cancellable?

    func testProviderHappyPath() {
        var result: GameData?

        cancellable = sut.provide(4).sink { result = $0 }

        XCTAssertEqual(result, GameData(rounds: [
            .init(questionWord: "1", answerWord: "1t", isTranslationCorrect: true),
            .init(questionWord: "2", answerWord: "2t", isTranslationCorrect: true),
            .init(questionWord: "3", answerWord: "5t", isTranslationCorrect: false),
            .init(questionWord: "4", answerWord: "6t", isTranslationCorrect: false)
        ]))
    }

    func testProviderRoundsExceeded() {
        var result: GameData?

        cancellable = sut.provide(8).sink { result = $0 }

        XCTAssertNil(result)
    }
}

private extension TranslatedWordsLoader {
    static let mock = TranslatedWordsLoader {
        Just([
            TranslatedWord(eng: "1", spa: "1t"),
            TranslatedWord(eng: "2", spa: "2t"),
            TranslatedWord(eng: "3", spa: "3t"),
            TranslatedWord(eng: "4", spa: "4t"),
            TranslatedWord(eng: "5", spa: "5t"),
            TranslatedWord(eng: "6", spa: "6t")
        ])
        .eraseToAnyPublisher()
    }
}
