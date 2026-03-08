import Foundation

protocol TextCaptureService {
    func captureText() async throws -> String
}
