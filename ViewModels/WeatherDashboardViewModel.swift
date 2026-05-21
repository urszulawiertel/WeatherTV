import Foundation

@MainActor
final class WeatherDashboardViewModel: ObservableObject {
    @Published private(set) var locationForecasts: [LocationForecastViewModel] = []

    private let weatherService: WeatherServiceProtocol
    private let locations: [Location]

    init(
        weatherService: WeatherServiceProtocol,
        locations: [Location] = Location.predefined
    ) {
        self.weatherService = weatherService
        self.locations = locations
        loadPlaceholderForecasts()
    }

    private func loadPlaceholderForecasts() {
        locationForecasts = locations.map { location in
            LocationForecastViewModel(
                location: location,
                forecasts: DailyForecast.placeholder
            )
        }
    }

    func loadForecasts() async {
        var rows: [LocationForecastViewModel] = []

        for location in locations {
            let forecasts = (try? await weatherService.fetchForecast(for: location)) ?? DailyForecast.placeholder
            rows.append(
                LocationForecastViewModel(
                    location: location,
                    forecasts: forecasts
                )
            )
        }

        locationForecasts = rows
    }
}
