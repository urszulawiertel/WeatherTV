import Foundation

struct OpenMeteoWeatherService: WeatherServiceProtocol {
    private let apiClient: WeatherAPIClient
    private let decoder: JSONDecoder

    init(
        apiClient: WeatherAPIClient = WeatherAPIClient(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        let endpoint = WeatherEndpoint(
            latitude: location.latitude,
            longitude: location.longitude
        )

        let data = try await apiClient.requestForecast(from: endpoint)

        do {
            let response = try decoder.decode(OpenMeteoForecastResponse.self, from: data)
            return OpenMeteoForecastMapper.map(response)
        } catch {
            throw WeatherAPIError.decodingFailed
        }
    }
}
