import Foundation

struct HTTPClient {
    var session: URLSession = .shared

    func get(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        try validate(response: response, data: data)
        return data
    }

    func send(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        return data
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslationNetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw TranslationNetworkError.httpError(statusCode: httpResponse.statusCode, message: message)
        }
    }
}

enum TranslationNetworkError: LocalizedError, Equatable {
    case invalidURL
    case missingConfiguration
    case invalidResponse
    case httpError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "翻译服务地址无效。"
        case .missingConfiguration:
            return "请先填写完整的自定义翻译服务配置。"
        case .invalidResponse:
            return "翻译服务返回了无法识别的数据。"
        case let .httpError(statusCode, message):
            return "翻译请求失败（\(statusCode)）：\(message)"
        }
    }
}
