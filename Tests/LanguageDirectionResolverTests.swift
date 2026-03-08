import XCTest
@testable import FlashTranslate

final class LanguageDirectionResolverTests: XCTestCase {
    func testChineseTextResolvesToEnglish() {
        let resolver = LanguageDirectionResolver()

        let result = resolver.resolve(for: "你好，世界")

        XCTAssertEqual(result, TranslationDirection(sourceLanguageCode: "zh-CN", targetLanguageCode: "en"))
    }

    func testEnglishTextResolvesToChinese() {
        let resolver = LanguageDirectionResolver()

        let result = resolver.resolve(for: "hello world")

        XCTAssertEqual(result, TranslationDirection(sourceLanguageCode: "en", targetLanguageCode: "zh-CN"))
    }
}
