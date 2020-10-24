import Foundation
import GameModule

public struct AppEnvironment {
    var gameModuleEnvironment: GameModule.ModuleEnvironment

    public static let live = AppEnvironment(
        gameModuleEnvironment: .live
    )
}

#if DEBUG
extension AppEnvironment {
    public static let mock = AppEnvironment(
        gameModuleEnvironment: .mock
    )
}
#endif
