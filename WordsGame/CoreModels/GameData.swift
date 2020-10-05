import Foundation

public struct GameData: Equatable {
    public let rounds: [RoundData]

    public init(rounds: [RoundData]) {
        self.rounds = rounds
    }
}

public struct RoundData: Equatable {
    public let questionWord: String
    public let answerWord: String
    public let isTranslationCorrect: Bool

    public init(
        questionWord: String,
        answerWord: String,
        isTranslationCorrect: Bool
    ) {
        self.questionWord = questionWord
        self.answerWord = answerWord
        self.isTranslationCorrect = isTranslationCorrect
    }
}
