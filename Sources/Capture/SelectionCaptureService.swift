import ApplicationServices
import Foundation

struct SelectionCaptureService: TextCaptureService {
    let permissionManager: PermissionManager
    let fallback: PasteboardCaptureFallback

    func captureText() async throws -> String {
        let accessibilityGranted = await MainActor.run { permissionManager.accessibilityGranted }

        guard accessibilityGranted else {
            throw PermissionError.accessibilityDenied
        }

        // 优先尝试直接读取选中文本
        if let focusedElement = focusedElement(),
           let selectedText = selectedTextValue(from: focusedElement),
           !selectedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return selectedText
        }

        // 如果无法直接读取，使用剪贴板方式
        return try await fallback.captureText()
    }

    private func focusedElement() -> AXUIElement? {
        let system = AXUIElementCreateSystemWide()
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &value)
        guard result == .success, let value else { return nil }
        return unsafeBitCast(value, to: AXUIElement.self)
    }

    private func selectedTextValue(from element: AXUIElement) -> String? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, kAXSelectedTextAttribute as CFString, &value)
        guard result == .success else { return nil }
        return value as? String
    }
}
