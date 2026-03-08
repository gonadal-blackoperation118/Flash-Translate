import AppKit
import Foundation

@MainActor
final class DoubleCommandDetector {
    var onDoubleCommand: (() -> Void)?

    private var lastCommandTap: Date?
    private let threshold: TimeInterval
    private var localMonitor: Any?

    init(threshold: TimeInterval = 0.28) {
        self.threshold = threshold
    }

    func start() {
        stop()
        localMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            guard let self else { return }
            guard event.modifierFlags.contains(.command), event.keyCode == 55 || event.keyCode == 54 else {
                return
            }

            let now = Date()
            if let lastCommandTap, now.timeIntervalSince(lastCommandTap) <= threshold {
                onDoubleCommand?()
                self.lastCommandTap = nil
            } else {
                self.lastCommandTap = now
            }
        }
    }

    func stop() {
        if let localMonitor {
            NSEvent.removeMonitor(localMonitor)
            self.localMonitor = nil
        }
    }
}
