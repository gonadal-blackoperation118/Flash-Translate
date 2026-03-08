import Foundation

@MainActor
enum AppBootstrap {
    static let sharedState = AppState.bootstrap()
}
