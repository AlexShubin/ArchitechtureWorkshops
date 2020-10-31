import Foundation
import GameModule

public struct AppEnvironment {
    var gameModule: GameModule.ModuleEnvironment

    public static let live = AppEnvironment(
        gameModule: .live
    )
}

#if DEBUG
extension AppEnvironment {
    public static let mock = AppEnvironment(
        gameModule: .mock
    )
}
#endif
