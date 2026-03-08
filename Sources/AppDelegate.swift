import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var appState: AppState?

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let appState else { return }

        let controller = MenuBarController(appState: appState)
        controller.install()
        menuBarController = controller
        appState.start()
    }
}
