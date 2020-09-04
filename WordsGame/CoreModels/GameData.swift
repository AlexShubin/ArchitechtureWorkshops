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

public extension GameData {
    static let `default` = GameData(rounds: [
        .init(questionWord: "Yes", answerWord: "Нет", isTranslationCorrect: false),
        .init(questionWord: "Cat", answerWord: "Кошка", isTranslationCorrect: true),
        .init(questionWord: "Good", answerWord: "Хорошо", isTranslationCorrect: true),
        .init(questionWord: "Bad", answerWord: "Плохо", isTranslationCorrect: true),
        .init(questionWord: "No", answerWord: "Да", isTranslationCorrect: false),
        .init(questionWord: "Dog", answerWord: "Собака", isTranslationCorrect: true),
        .init(questionWord: "Hi", answerWord: "Привет", isTranslationCorrect: true)
    ])
}
