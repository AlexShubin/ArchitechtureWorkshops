import Foundation
import Combine
import CoreModels

public struct GameDataProvider {
    public var provide: (_ roundsCount: Int) -> AnyPublisher<GameData?, Never>

    static func make(translatedWordsLoader: TranslatedWordsLoader,
                     randomNumberGenerator: GameRandomNumberGenerator) -> GameDataProvider {
        var randomNumberGenerator = randomNumberGenerator

        return GameDataProvider { roundsCount in
            translatedWordsLoader.load()
                .map { allWords -> GameData? in
                    guard let allWords = allWords, roundsCount <= allWords.count else {
                        return nil
                    }

                    let allWordsShuffled = allWords.shuffled(using: &randomNumberGenerator)

                    let shuffledPrefix = Array(allWordsShuffled.prefix(roundsCount))
                    let shuffledSuffix = Array(allWordsShuffled.suffix(roundsCount))

                    var result: [RoundData] = []

                    for i in (0..<roundsCount) {
                        if i < roundsCount/2 {
                            result.append(.init(questionWord: shuffledPrefix[i].eng,
                                                answerWord: shuffledPrefix[i].spa,
                                                isTranslationCorrect: true))
                        } else {
                            result.append(.init(questionWord: shuffledPrefix[i].eng,
                                                answerWord: shuffledSuffix[i].spa,
                                                isTranslationCorrect: shuffledSuffix[i].spa == shuffledPrefix[i].spa))
                        }
                    }

                    return GameData(rounds: result.shuffled(using: &randomNumberGenerator))
            }
            .eraseToAnyPublisher()
        }
    }

    public static let live = GameDataProvider.make(translatedWordsLoader: .live,
                                                   randomNumberGenerator: .live)

    #if DEBUG
    public static let mock = GameDataProvider { _ in
        Just(GameData(rounds: [
            .init(questionWord: "1", answerWord: "1t", isTranslationCorrect: true),
            .init(questionWord: "2", answerWord: "2t", isTranslationCorrect: true)
            ])).eraseToAnyPublisher()
    }
    #endif
}

struct GameRandomNumberGenerator: RandomNumberGenerator {
    let random: () -> UInt64

    func next() -> UInt64 {
        random()
    }

    static let live = GameRandomNumberGenerator {
        UInt64.random(in: 0...UInt64.max)
    }

    #if DEBUG
    static let mock = GameRandomNumberGenerator { 1 }
    #endif
}

struct TranslatedWordsLoader {
    let load: () -> AnyPublisher<[TranslatedWord]?, Never>

    private static let urlSession = URLSession.shared

    private static let decoder = JSONDecoder()

    static let live = TranslatedWordsLoader {
        let url = URL(string: "https://raw.githubusercontent.com/AlexShubin/ArchitechtureWorkshops/master/words.json")!

        return urlSession.dataTaskPublisher(for: url)
            .map { data, _ in data }
            .decode(type: [TranslatedWord]?.self, decoder: decoder)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

struct TranslatedWord: Decodable, Equatable {
    let eng: String
    let spa: String

    // MARK: Decodable
    private enum CodingKeys: String, CodingKey {
        case eng = "text_eng"
        case spa = "text_spa"
    }
}
