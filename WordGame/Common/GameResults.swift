public struct GameResults: Equatable {
    public var rightAnswers: Int
    public var wrongAnswers: Int

    public init(rightAnswers: Int, wrongAnswers: Int) {
        self.rightAnswers = rightAnswers
        self.wrongAnswers = wrongAnswers
    }

    public static let empty = GameResults(rightAnswers: 0, wrongAnswers: 0)
}
