import Foundation
import Combine

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var effectCancellables: Set<AnyCancellable> = []

    init(initialState: State,
         reducer: @escaping Reducer<State, Action, Environment>,
         environment: Environment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else { return }

        var effectCancellable: AnyCancellable?
        effectCancellable = effect.sink(
            receiveCompletion: { [weak self] _ in
                if let effectCancellable = effectCancellable {
                    self?.effectCancellables.remove(effectCancellable)
                }
            },
            receiveValue: send
        )
        if let effectCancellable = effectCancellable {
           effectCancellables.insert(effectCancellable)
        }
    }
}

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> Effect<Action>?

public struct Effect<Output>: Publisher {
    public typealias Failure = Never

    let publisher: AnyPublisher<Output, Failure>

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.publisher.receive(subscriber: subscriber)
    }
}

extension Publisher where Failure == Never {
    public func eraseToEffect() -> Effect<Output> {
        return Effect(publisher: self.eraseToAnyPublisher())
    }
}
