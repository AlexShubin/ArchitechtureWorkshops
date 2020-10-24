import SwiftUI
import ComposableArchitecture

public struct ScoreHistoryView: View {
    let store: ModuleStore

    public init(store: ModuleStore) {
        self.store = store
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.state.scoreHistory.activities) { activity in
                        VStack {
                            Text("Completed at: \(self.dateFormatter.string(from: activity.timestamp))")
                                .foregroundColor(.blue)
                            Text("Correct answers: \(activity.results.rightAnswers)")
                            Text("Wrong answers: \(activity.results.wrongAnswers)")
                        }
                        .padding(5)
                    }
                    .onDelete { indexSet in
                        viewStore.send(.removeActivities(indexSet: indexSet))
                    }
                }
                .navigationBarTitle(Text("Score"))
            }
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 10),
                  results: .init(rightAnswers: 1, wrongAnswers: 1)),
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 20),
                  results: .init(rightAnswers: 2, wrongAnswers: 2))
        ]

        return ScoreHistoryView(store: ModuleStore(initialState: state, reducer: reducer, environment: ()))
    }
}
