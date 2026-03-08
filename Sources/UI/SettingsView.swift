import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState

    private var settingsBinding: Binding<AppSettings> {
        Binding(
            get: { appState.settingsStore.settings },
            set: { appState.settingsStore.save($0) }
        )
    }

    var body: some View {
        Form {
            Section("翻译服务") {
                Picker("Provider", selection: settingsBinding.provider) {
                    ForEach(TranslationProvider.allCases) { provider in
                        Text(provider.displayName).tag(provider)
                    }
                }
                .pickerStyle(.segmented)

                TextField("Base URL", text: settingsBinding.baseURL)
                    .textFieldStyle(.roundedBorder)
                SecureField("API Key", text: settingsBinding.apiKey)
                    .textFieldStyle(.roundedBorder)
                TextField("Model", text: settingsBinding.model)
                    .textFieldStyle(.roundedBorder)
            }

            Section("快捷键") {
                TextField("快捷键", text: settingsBinding.hotkeyDisplay)
                    .textFieldStyle(.roundedBorder)
                Text("双击 Command 键即可触发翻译，也可以使用自定义快捷键。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("权限") {
                Label(appState.permissionManager.accessibilityStatusText, systemImage: appState.permissionManager.accessibilityGranted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(appState.permissionManager.accessibilityGranted ? .green : .orange)

                Button("重新申请辅助功能权限") {
                    appState.reopenPermissionGuidance()
                }
            }
        }
        .padding()
    }
}

private extension Binding where Value == AppSettings {
    var provider: Binding<TranslationProvider> {
        Binding<TranslationProvider>(
            get: { wrappedValue.provider },
            set: { wrappedValue.provider = $0 }
        )
    }

    var baseURL: Binding<String> {
        Binding<String>(
            get: { wrappedValue.baseURL },
            set: { wrappedValue.baseURL = $0 }
        )
    }

    var apiKey: Binding<String> {
        Binding<String>(
            get: { wrappedValue.apiKey },
            set: { wrappedValue.apiKey = $0 }
        )
    }

    var model: Binding<String> {
        Binding<String>(
            get: { wrappedValue.model },
            set: { wrappedValue.model = $0 }
        )
    }

    var hotkeyDisplay: Binding<String> {
        Binding<String>(
            get: { wrappedValue.hotkeyDisplay },
            set: { wrappedValue.hotkeyDisplay = $0 }
        )
    }
}
