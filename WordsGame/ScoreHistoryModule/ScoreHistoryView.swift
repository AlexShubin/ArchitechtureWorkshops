import SwiftUI
import ComposableArchitecture

public struct ScoreHistoryView: View {
    let store: ModuleStore
    let viewStateConverter: ScoreHistoryViewStateConverter = .live
    
    public init(store: ModuleStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store.scope(state: viewStateConverter.convert)) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.activities) { activity in
                        VStack {
                            Text("Completed at: \(activity.time))")
                                .foregroundColor(.blue)
                            Text("Correct answers: \(activity.rightAnswers)")
                            Text("Wrong answers: \(activity.wrongAnswers)")
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
