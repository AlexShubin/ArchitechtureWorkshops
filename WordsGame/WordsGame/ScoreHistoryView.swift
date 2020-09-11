import SwiftUI

struct ScoreHistoryView: View {
    @ObservedObject var store: AppStore

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.scoreHistory.activities) { activity in
                    VStack {
                        Text("Completed at: \(self.formatter.string(from: activity.timestamp))")
                            .foregroundColor(.blue)
                        Text("Correct answers: \(activity.results.rightAnswers)")
                        Text("Wrong answers: \(activity.results.wrongAnswers)")
                    }
                    .padding(5)
                }
                .onDelete {
                    self.store.send(.removeActivities(indexSet: $0))
                }
            }
            .navigationBarTitle(Text("Score"))
        }
    }
}

struct ScoreHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        var state = AppState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(),
                  results: .init(rightAnswers: 1, wrongAnswers: 1)),
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 10),
                  results: .init(rightAnswers: 5, wrongAnswers: 1)),
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 20),
                  results: .init(rightAnswers: 1, wrongAnswers: 5))
        ]
        return ScoreHistoryView(store: AppStore(initialState: state, reducer: reducer))
    }
}
