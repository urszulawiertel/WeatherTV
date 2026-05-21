import Foundation

struct WeatherAPIClient {
    func requestForecast(from endpoint: WeatherEndpoint) async throws -> Data {
        // Real networking will be implemented in a later stage.
        _ = endpoint
        return Data()
    }
}
