import SwiftUI
import ComposableArchitecture

public struct GameStartView: View {
    let store: ModuleStore
    let viewStateConverter = GameStartViewStateConverter.live
    
    public init(store: ModuleStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store.scope(state: viewStateConverter.convert)) { viewStore in
            VStack(spacing: 10) {
                Button(action: { viewStore.send(.startGame) },
                       label: { Text("Start game") })
                    .font(.largeTitle)
                    .sheet(isPresented: Binding.constant(viewStore.state.isGameStarted),
                           onDismiss: { viewStore.send(.stopGame) },
                           content: { GameView(store: self.store) })
                results
            }
        }
    }
    
    private var results: AnyView {
        AnyView(
            WithViewStore(store.scope(state: viewStateConverter.convert)) { viewStore -> AnyView in
                guard let latestActivity = viewStore.latestActivity else {
                    return AnyView(EmptyView())
                }
                return AnyView(
                    VStack(spacing: 10) {
                        Text("Your latest result: ")
                            .font(.title)
                        Text("Correct answers: \(latestActivity.rightAnswers)")
                        Text("Wrong answers: \(latestActivity.wrongAnswers)")
                    }
                    .font(.headline)
                )
            }
        )
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        var state = ModuleState()
        state.scoreHistory.activities = [
            .init(id: UUID(),
                  timestamp: Date(timeIntervalSinceNow: 10),
                  results: .init(rightAnswers: 2, wrongAnswers: 2))
        ]
        return GameStartView(store: ModuleStore(initialState: state, reducer: reducer, environment: .live))
    }
}
