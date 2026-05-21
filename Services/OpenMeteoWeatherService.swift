import Foundation

struct OpenMeteoWeatherService: WeatherServiceProtocol {
    private let apiClient: WeatherAPIClient

    init(apiClient: WeatherAPIClient = WeatherAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        let endpoint = WeatherEndpoint(
            latitude: location.latitude,
            longitude: location.longitude
        )

        _ = try await apiClient.requestForecast(from: endpoint)

        // Response decoding will be implemented in the API integration stage.
        return []
    }
}
