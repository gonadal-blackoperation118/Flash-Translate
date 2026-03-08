import XCTest
@testable import FlashTranslate

@MainActor
final class SettingsStoreTests: XCTestCase {
    func testSaveAndReloadSettings() {
        let suiteName = "SettingsStoreTests"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let store = SettingsStore(defaults: defaults)
        var updated = AppSettings()
        updated.provider = .openAICompatible
        updated.baseURL = "https://example.com/v1"
        updated.apiKey = "secret"
        updated.model = "gpt-test"
        store.save(updated)

        let reloaded = SettingsStore(defaults: defaults)

        XCTAssertEqual(reloaded.settings, updated)
    }
}
