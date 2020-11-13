import GameModule

struct AppEnvironment {
    var gameModule: GameModule.ModuleEnvironment
    
    static let live = AppEnvironment(gameModule: .live)
}

#if DEBUG
extension AppEnvironment {
    static let mock = AppEnvironment(gameModule: .mock)
}
#endif
