import Foundation

struct DailyForecast: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let condition: String
    let iconName: String
    let highTemperature: Int
    let lowTemperature: Int
    let precipitationProbability: Int?
    let windSpeed: Double?

    init(
        id: UUID = UUID(),
        date: Date,
        condition: String,
        iconName: String = "cloud.sun.fill",
        highTemperature: Int,
        lowTemperature: Int,
        precipitationProbability: Int? = nil,
        windSpeed: Double? = nil
    ) {
        self.id = id
        self.date = date
        self.condition = condition
        self.iconName = iconName
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.precipitationProbability = precipitationProbability
        self.windSpeed = windSpeed
    }
}

extension DailyForecast {
    static let placeholder: [DailyForecast] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let conditions = [
            ForecastCondition.sunny,
            .partlyCloudy,
            .cloudy,
            .rain,
            .clear
        ]

        return (0..<5).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else {
                return nil
            }

            return DailyForecast(
                date: date,
                condition: conditions[offset % conditions.count].localizedDescription,
                iconName: conditions[offset % conditions.count].iconName,
                highTemperature: 18 + offset,
                lowTemperature: 9 + offset,
                precipitationProbability: [10, 20, 35, 70, 5][offset],
                windSpeed: Double(12 + offset)
            )
        }
    }()
}

enum ForecastCondition {
    case clear
    case sunny
    case partlyCloudy
    case cloudy
    case fog
    case drizzle
    case rain
    case snow
    case thunderstorm
    case unknown

    var localizedDescription: String {
        switch self {
        case .clear:
            return L10n.ForecastCondition.clear
        case .sunny:
            return L10n.ForecastCondition.sunny
        case .partlyCloudy:
            return L10n.ForecastCondition.partlyCloudy
        case .cloudy:
            return L10n.ForecastCondition.cloudy
        case .fog:
            return L10n.ForecastCondition.fog
        case .drizzle:
            return L10n.ForecastCondition.drizzle
        case .rain:
            return L10n.ForecastCondition.rain
        case .snow:
            return L10n.ForecastCondition.snow
        case .thunderstorm:
            return L10n.ForecastCondition.thunderstorm
        case .unknown:
            return L10n.ForecastCondition.unknown
        }
    }

    var iconName: String {
        switch self {
        case .clear, .sunny:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .fog:
            return "cloud.fog.fill"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .rain:
            return "cloud.rain.fill"
        case .snow:
            return "cloud.snow.fill"
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
}
