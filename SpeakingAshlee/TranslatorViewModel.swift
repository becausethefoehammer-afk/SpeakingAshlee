import Foundation

@MainActor
class TranslatorViewModel: ObservableObject {
    @Published var outputText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showCopied = false

    func translate(_ input: String) async {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        outputText = ""
        errorMessage = nil

        do {
            outputText = try await callProxy(input: trimmed)
        } catch {
            errorMessage = "no wifi or bad vibes: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func callProxy(input: String) async throws -> String {
        guard let url = URL(string: "\(APIConfig.proxyBaseURL)/translate") else {
            throw TranslatorError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["input": input])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslatorError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            let msg = (try? JSONDecoder().decode(ProxyError.self, from: data))?.error ?? "HTTP \(httpResponse.statusCode)"
            throw TranslatorError.apiError(msg)
        }

        let decoded = try JSONDecoder().decode(ProxyResponse.self, from: data)
        return decoded.translation
    }
}

enum TranslatorError: LocalizedError {
    case badURL
    case invalidResponse
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .badURL: return "bad proxy URL in config"
        case .invalidResponse: return "invalid response from server"
        case .apiError(let msg): return msg
        }
    }
}

private struct ProxyResponse: Decodable {
    let translation: String
}

private struct ProxyError: Decodable {
    let error: String
}
