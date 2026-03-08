import AppKit
import Carbon
import Foundation

@MainActor
final class HotkeyManager {
    var onTrigger: (() -> Void)?

    private let settingsStore: SettingsStore
    private var eventMonitor: Any?

    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
    }

    func start() {
        stop()
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return }
            let shortcut = self.settingsStore.settings.hotkey
            if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == shortcut.modifiers,
               event.keyCode == shortcut.keyCode {
                self.onTrigger?()
            }
        }
    }

    func stop() {
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
    }
}
