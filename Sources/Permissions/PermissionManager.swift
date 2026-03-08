import ApplicationServices
import AppKit
import Foundation

@MainActor
final class PermissionManager: ObservableObject {
    @Published private(set) var accessibilityGranted = AXIsProcessTrusted()

    var accessibilityStatusText: String {
        accessibilityGranted ? "辅助功能权限已授权" : "需要辅助功能权限来读取选中文本"
    }

    func refresh() {
        accessibilityGranted = AXIsProcessTrusted()
    }

    func ensureCapturePermissionIfPossible() throws {
        refresh()
        if !accessibilityGranted {
            throw PermissionError.accessibilityDenied
        }
    }

    func promptForAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
        refresh()
    }

    func openInputMonitoringSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

enum PermissionError: LocalizedError {
    case accessibilityDenied

    var errorDescription: String? {
        switch self {
        case .accessibilityDenied:
            return "请先在系统设置中授予辅助功能权限，然后再试一次。"
        }
    }
}
