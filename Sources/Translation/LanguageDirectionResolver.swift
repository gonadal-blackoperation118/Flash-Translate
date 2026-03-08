import Foundation

struct LanguageDirectionResolver {
    func resolve(for text: String) -> TranslationDirection {
        let characters = Array(text)
        let chineseCount = characters.filter { $0.isChineseCharacter }.count
        let latinCount = characters.filter { $0.isASCII && $0.isLetter }.count

        if chineseCount >= max(1, latinCount) {
            return TranslationDirection(sourceLanguageCode: "zh-CN", targetLanguageCode: "en")
        }

        return TranslationDirection(sourceLanguageCode: "en", targetLanguageCode: "zh-CN")
    }
}

private extension Character {
    var isChineseCharacter: Bool {
        unicodeScalars.contains { scalar in
            (0x4E00...0x9FFF).contains(scalar.value) ||
            (0x3400...0x4DBF).contains(scalar.value)
        }
    }
}
