import Foundation

public struct ScoreHistory: Equatable {
    public var activities: [Activity]

    public init(activities: [Activity]) {
        self.activities = activities
    }

    public struct Activity: Identifiable, Equatable {
        public let id: UUID
        public let timestamp: Date
        public let results: GameResults

        public init(id: UUID,
                    timestamp: Date,
                    results: GameResults) {
            self.id = id
            self.timestamp = timestamp
            self.results = results
        }
    }

    public static let empty = ScoreHistory(activities: [])
}
