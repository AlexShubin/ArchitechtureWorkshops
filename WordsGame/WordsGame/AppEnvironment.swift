import Foundation
import ServiceKit
import CoreModels

public struct AppEnvironment {
    var gameDataProvider: GameDataProvider
    var dateProvider:  () -> Date
    var uuidProvider: () -> UUID

    public static let live = AppEnvironment(
        gameDataProvider: .live,
        dateProvider: Date.init,
        uuidProvider: UUID.init
    )
}

#if DEBUG
extension AppEnvironment {
    public static let mock = AppEnvironment(
        gameDataProvider: .mock,
        dateProvider: { Date(timeIntervalSince1970: 0) },
        uuidProvider: { .fakeUUID }
    )
}
#endif

