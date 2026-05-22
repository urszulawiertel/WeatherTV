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
                condition: condition.description,
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

    var description: String {
        switch code {
        case 0:
            return "Clear"
        case 1, 2:
            return "Partly Cloudy"
        case 3:
            return "Cloudy"
        case 45, 48:
            return "Fog"
        case 51, 53, 55, 56, 57:
            return "Drizzle"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "Rain"
        case 71, 73, 75, 77, 85, 86:
            return "Snow"
        case 95, 96, 99:
            return "Thunderstorm"
        default:
            return "Unknown"
        }
    }

    var iconName: String {
        switch code {
        case 0:
            return "sun.max.fill"
        case 1, 2:
            return "cloud.sun.fill"
        case 3:
            return "cloud.fill"
        case 45, 48:
            return "cloud.fog.fill"
        case 51, 53, 55, 56, 57:
            return "cloud.drizzle.fill"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "cloud.rain.fill"
        case 71, 73, 75, 77, 85, 86:
            return "cloud.snow.fill"
        case 95, 96, 99:
            return "cloud.bolt.rain.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
