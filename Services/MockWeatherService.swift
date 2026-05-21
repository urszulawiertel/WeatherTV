import Foundation

struct MockWeatherService: WeatherServiceProtocol {
    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        DailyForecast.placeholder.enumerated().map { index, forecast in
            DailyForecast(
                date: forecast.date,
                condition: forecast.condition,
                highTemperature: forecast.highTemperature + temperatureOffset(for: location) + index,
                lowTemperature: forecast.lowTemperature + temperatureOffset(for: location)
            )
        }
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
