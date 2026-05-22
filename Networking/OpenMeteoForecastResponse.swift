import Foundation

struct OpenMeteoForecastResponse: Decodable {
    let daily: OpenMeteoDailyForecast
}

struct OpenMeteoDailyForecast: Decodable {
    let time: [String]
    let weatherCode: [Int]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let precipitationProbabilityMax: [Int]?
    let windSpeedMax: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case windSpeedMax = "wind_speed_10m_max"
    }
}

enum OpenMeteoForecastMapper {
    static func map(_ response: OpenMeteoForecastResponse) -> [DailyForecast] {
        response.daily.time.indices.compactMap { index in
            guard
                let date = dateFormatter.date(from: response.daily.time[index]),
                let weatherCode = response.daily.weatherCode[safe: index],
                let temperatureMax = response.daily.temperatureMax[safe: index],
                let temperatureMin = response.daily.temperatureMin[safe: index]
            else {
                return nil
            }

            let condition = OpenMeteoWeatherCode(code: weatherCode)

            return DailyForecast(
                date: date,
                condition: condition.forecastCondition.localizedDescription,
                iconName: condition.iconName,
                highTemperature: Int(temperatureMax.rounded()),
                lowTemperature: Int(temperatureMin.rounded()),
                precipitationProbability: response.daily.precipitationProbabilityMax?[safe: index],
                windSpeed: response.daily.windSpeedMax?[safe: index]
            )
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

private struct OpenMeteoWeatherCode {
    let code: Int

    var forecastCondition: ForecastCondition {
        switch code {
        case 0:
            return .clear
        case 1, 2:
            return .partlyCloudy
        case 3:
            return .cloudy
        case 45, 48:
            return .fog
        case 51, 53, 55, 56, 57:
            return .drizzle
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return .rain
        case 71, 73, 75, 77, 85, 86:
            return .snow
        case 95, 96, 99:
            return .thunderstorm
        default:
            return .unknown
        }
    }

    var iconName: String {
        forecastCondition.iconName
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
