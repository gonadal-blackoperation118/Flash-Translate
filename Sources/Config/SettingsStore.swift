import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var settings: AppSettings

    private let defaults: UserDefaults
    private let key = "flash_translate_settings"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = AppSettings()
        }
    }

    func save(_ settings: AppSettings) {
        self.settings = settings
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: key)
        }
    }
}
