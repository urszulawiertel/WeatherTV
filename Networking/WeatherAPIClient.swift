import Foundation

enum WeatherAPIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError
    case unknown
}

protocol UserDisplayableError: LocalizedError {}

extension WeatherAPIError: UserDisplayableError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L10n.Error.invalidURL
        case .invalidResponse:
            return L10n.Error.invalidResponse
        case .decodingFailed:
            return L10n.Error.decodingFailed
        case .serverError:
            return L10n.Error.serverError
        case .unknown:
            return L10n.Error.unknown
        }
    }
}

struct WeatherAPIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func requestForecast(from endpoint: WeatherEndpoint) async throws -> Data {
        guard let url = endpoint.url else {
            throw WeatherAPIError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            try validate(response: response)
            return data
        } catch let error as WeatherAPIError {
            throw error
        } catch {
            if error is CancellationError {
                throw error
            }

            throw WeatherAPIError.unknown
        }
    }

    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherAPIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 500..<600:
            throw WeatherAPIError.serverError
        default:
            throw WeatherAPIError.invalidResponse
        }
    }
}
