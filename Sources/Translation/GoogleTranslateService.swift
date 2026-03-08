import Foundation

struct GoogleTranslateService {
    let httpClient: HTTPClient

    func translate(text: String, direction: TranslationDirection) async throws -> String {
        var components = URLComponents(string: "https://translate.googleapis.com/translate_a/single")
        components?.queryItems = [
            URLQueryItem(name: "client", value: "gtx"),
            URLQueryItem(name: "sl", value: direction.sourceLanguageCode),
            URLQueryItem(name: "tl", value: direction.targetLanguageCode),
            URLQueryItem(name: "dt", value: "t"),
            URLQueryItem(name: "q", value: text)
        ]

        guard let url = components?.url else {
            throw TranslationNetworkError.invalidURL
        }

        let data = try await httpClient.get(url: url)
        return try GoogleTranslateParser.parse(data: data)
    }
}

enum GoogleTranslateParser {
    static func parse(data: Data) throws -> String {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [Any],
            let sentences = json.first as? [Any]
        else {
            throw TranslationNetworkError.invalidResponse
        }

        let translated = sentences.compactMap { sentence -> String? in
            guard let item = sentence as? [Any], let text = item.first as? String else {
                return nil
            }
            return text
        }.joined()

        if translated.isEmpty {
            throw TranslationNetworkError.invalidResponse
        }

        return translated
    }
}
