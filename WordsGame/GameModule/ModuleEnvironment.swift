import Foundation
import ServiceKit
import CoreModels
import ComposableArchitecture

public struct ModuleEnvironment {
    var gameDataProvider: GameDataProvider
    var dateProvider: () -> Date
    var uuidProvider: () -> UUID
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public static let live = ModuleEnvironment(
        gameDataProvider: .live,
        dateProvider: Date.init,
        uuidProvider: UUID.init,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}

#if DEBUG
extension ModuleEnvironment {
    public static let mock = ModuleEnvironment(
        gameDataProvider: .mock,
        dateProvider: { Date(timeIntervalSince1970: 0) },
        uuidProvider: { .fakeUUID },
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
#endif
