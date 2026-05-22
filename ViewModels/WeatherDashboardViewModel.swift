import Foundation

enum DashboardState: Equatable {
    case idle
    case loading
    case loaded([LocationForecastViewModel])
    case empty
    case failed(ErrorViewState)
}

struct ErrorViewState: Equatable {
    let title: String
    let message: String

    init(
        title: String = "Forecast unavailable",
        message: String
    ) {
        self.title = title
        self.message = message
    }
}

@MainActor
final class WeatherDashboardViewModel: ObservableObject {
    @Published private(set) var state: DashboardState = .idle

    private let weatherService: WeatherServiceProtocol
    private let locations: [Location]

    init(
        weatherService: WeatherServiceProtocol,
        locations: [Location] = Location.predefined
    ) {
        self.weatherService = weatherService
        self.locations = locations
    }

    func loadForecasts() async {
        guard state != .loading else {
            return
        }

        state = .loading

        do {
            let rows = try await fetchLocationForecasts()
            state = rows.isEmpty ? .empty : .loaded(rows)
        } catch {
            state = .failed(
                ErrorViewState(
                    message: error.localizedDescription
                )
            )
        }
    }

    func retry() async {
        await loadForecasts()
    }

    private func fetchLocationForecasts() async throws -> [LocationForecastViewModel] {
        var rows: [LocationForecastViewModel] = []

        for location in locations {
            let forecasts = try await weatherService.fetchForecast(for: location)

            guard !forecasts.isEmpty else {
                continue
            }

            rows.append(
                LocationForecastViewModel(
                    location: location,
                    forecasts: forecasts
                )
            )
        }

        return rows
    }
}
