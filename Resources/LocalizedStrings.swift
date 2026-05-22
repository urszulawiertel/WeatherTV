import Foundation

enum L10n {
    enum Dashboard {
        static let title = localized("dashboard.title", defaultValue: "WeatherTV")
        static let subtitle = localized("dashboard.subtitle", defaultValue: "Multi-day forecast")
        static let loadingTitle = localized("dashboard.loading.title", defaultValue: "Loading forecasts")
        static let loadingMessage = localized(
            "dashboard.loading.message",
            defaultValue: "Getting the latest weather for your saved locations."
        )
        static let emptyTitle = localized("dashboard.empty.title", defaultValue: "No forecasts available")
        static let emptyMessage = localized(
            "dashboard.empty.message",
            defaultValue: "There is no forecast data to show right now."
        )
        static let retryButton = localized("dashboard.retry.button", defaultValue: "Retry")
    }

    enum ForecastDetails {
        static let high = localized("forecast.details.high", defaultValue: "High")
        static let low = localized("forecast.details.low", defaultValue: "Low")
        static let precipitation = localized("forecast.details.precipitation", defaultValue: "Precipitation")
        static let wind = localized("forecast.details.wind", defaultValue: "Wind")
        static func windSpeed(_ value: Int) -> String {
            String(
                format: localized("forecast.details.wind.speed", defaultValue: "%d km/h"),
                value
            )
        }
    }

    enum ForecastCondition {
        static let clear = localized("forecast.condition.clear", defaultValue: "Clear")
        static let sunny = localized("forecast.condition.sunny", defaultValue: "Sunny")
        static let partlyCloudy = localized("forecast.condition.partlyCloudy", defaultValue: "Partly Cloudy")
        static let cloudy = localized("forecast.condition.cloudy", defaultValue: "Cloudy")
        static let fog = localized("forecast.condition.fog", defaultValue: "Fog")
        static let drizzle = localized("forecast.condition.drizzle", defaultValue: "Drizzle")
        static let rain = localized("forecast.condition.rain", defaultValue: "Rain")
        static let snow = localized("forecast.condition.snow", defaultValue: "Snow")
        static let thunderstorm = localized("forecast.condition.thunderstorm", defaultValue: "Thunderstorm")
        static let unknown = localized("forecast.condition.unknown", defaultValue: "Unknown")
    }

    enum Error {
        static let forecastUnavailableTitle = localized(
            "error.forecastUnavailable.title",
            defaultValue: "Forecast unavailable"
        )
        static let forecastLoadFailedMessage = localized(
            "error.forecastLoadFailed.message",
            defaultValue: "The forecast could not be loaded. Please try again in a moment."
        )
        static let invalidURL = localized(
            "error.weather.invalidURL",
            defaultValue: "The weather request URL is invalid."
        )
        static let invalidResponse = localized(
            "error.weather.invalidResponse",
            defaultValue: "The weather service returned an invalid response."
        )
        static let decodingFailed = localized(
            "error.weather.decodingFailed",
            defaultValue: "The weather response could not be decoded."
        )
        static let serverError = localized(
            "error.weather.serverError",
            defaultValue: "The weather service is temporarily unavailable."
        )
        static let unknown = localized(
            "error.weather.unknown",
            defaultValue: "An unknown weather service error occurred."
        )
    }

    private static func localized(_ key: String, defaultValue: String) -> String {
        Bundle.main.localizedString(forKey: key, value: defaultValue, table: nil)
    }
}
