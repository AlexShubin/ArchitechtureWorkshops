import CoreModels
import ServiceKit
import ComposableArchitecture

public struct ModuleState: Equatable {
    public var scoreHistory = ScoreHistory.empty

    public init(scoreHistory: ScoreHistory = .empty) {
        self.scoreHistory = scoreHistory
    }
}

public enum ModuleAction: Equatable {
    case removeActivities(indexSet: IndexSet)
}

public let reducer = Reducer<ModuleState, ModuleAction, Void> { state, action, _ in
    switch action {
    case .removeActivities(let indexSet):
        state.scoreHistory.activities.remove(at: indexSet)
    }
    return .none
}

extension Array {
    mutating func remove(at indexes: IndexSet) {
        var enumerated = Swift.Array(self.enumerated())
        enumerated.removeAll { indexes.contains($0.offset) }
        self = enumerated.map { $0.element }
    }
}

public typealias ModuleStore = Store<ModuleState, ModuleAction>


