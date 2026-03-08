import AppKit
import Foundation

struct PasteboardCaptureFallback: TextCaptureService {
    let permissionManager: PermissionManager

    func captureText() async throws -> String {
        let pasteboard = NSPasteboard.general
        let originalString = pasteboard.string(forType: .string)
        let originalChangeCount = pasteboard.changeCount
        let accessibilityGranted = await MainActor.run { permissionManager.accessibilityGranted }

        guard accessibilityGranted else {
            throw PermissionError.accessibilityDenied
        }

        let source = CGEventSource(stateID: .hidSystemState)
        let commandDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
        let cDown = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: true)
        cDown?.flags = .maskCommand
        let cUp = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        let commandUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)

        commandDown?.post(tap: .cghidEventTap)
        cDown?.post(tap: .cghidEventTap)
        cUp?.post(tap: .cghidEventTap)
        commandUp?.post(tap: .cghidEventTap)

        try await Task.sleep(for: .milliseconds(180))
        let captured = pasteboard.string(forType: .string) ?? ""

        if pasteboard.changeCount != originalChangeCount {
            pasteboard.clearContents()
            if let originalString {
                pasteboard.setString(originalString, forType: .string)
            }
        }

        return captured
    }
}
