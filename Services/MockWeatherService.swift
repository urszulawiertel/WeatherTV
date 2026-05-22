import Foundation

final class MockWeatherService: WeatherServiceProtocol {
    enum Scenario {
        case success
        case empty
        case failure
    }

    enum MockWeatherError: Error {
        case forecastUnavailable
    }

    private let scenario: Scenario
    private var remainingScenarios: [Scenario]

    init(scenario: Scenario = .success) {
        self.scenario = scenario
        remainingScenarios = []
    }

    init(scenarios: [Scenario]) {
        scenario = scenarios.last ?? .success
        remainingScenarios = scenarios
    }

    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        switch nextScenario() {
        case .success:
            return forecast(for: location)
        case .empty:
            return []
        case .failure:
            throw MockWeatherError.forecastUnavailable
        }
    }

    private func forecast(for location: Location) -> [DailyForecast] {
        DailyForecast.placeholder.enumerated().map { index, forecast in
            DailyForecast(
                date: forecast.date,
                condition: forecast.condition,
                iconName: forecast.iconName,
                highTemperature: forecast.highTemperature + temperatureOffset(for: location) + index,
                lowTemperature: forecast.lowTemperature + temperatureOffset(for: location),
                precipitationProbability: forecast.precipitationProbability,
                windSpeed: forecast.windSpeed
            )
        }
    }

    private func nextScenario() -> Scenario {
        guard !remainingScenarios.isEmpty else {
            return scenario
        }

        return remainingScenarios.removeFirst()
    }

    private func temperatureOffset(for location: Location) -> Int {
        switch location.name {
        case "Dubai":
            return 13
        case "London":
            return -2
        case "Warsaw":
            return 1
        default:
            return 0
        }
    }
}

extension MockWeatherService.MockWeatherError: UserDisplayableError {
    var errorDescription: String? {
        L10n.Error.serverError
    }
}
