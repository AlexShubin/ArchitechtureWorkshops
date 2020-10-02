import Foundation
import Combine
import CoreModels

public struct GameDataProvider {
    public var provide: (_ roundsCount: Int) -> AnyPublisher<GameData?, Never>

    static func make(translatedWordsLoader: TranslatedWordsLoader) -> GameDataProvider {
        return GameDataProvider { roundsCount in
            translatedWordsLoader.load()
                .map { allWords -> GameData? in
                    guard let allWords = allWords, roundsCount <= allWords.count else {
                        return nil
                    }

                    let allWordsShuffled = allWords.shuffled()

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

                    return GameData(rounds: result.shuffled())
            }
            .eraseToAnyPublisher()
        }
    }

    public static let live = GameDataProvider.make(translatedWordsLoader: .live)
}

struct TranslatedWordsLoader {
    let load: () -> AnyPublisher<[TranslatedWord]?, Never>

    private static let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        return URLSession(configuration: config)
    }()

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
