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
        let conditions = ["Sunny", "Partly Cloudy", "Cloudy", "Rain", "Clear"]

        return (0..<5).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else {
                return nil
            }

            return DailyForecast(
                date: date,
                condition: conditions[offset % conditions.count],
                iconName: iconName(for: conditions[offset % conditions.count]),
                highTemperature: 18 + offset,
                lowTemperature: 9 + offset,
                precipitationProbability: [10, 20, 35, 70, 5][offset],
                windSpeed: Double(12 + offset)
            )
        }
    }()

    private static func iconName(for condition: String) -> String {
        switch condition {
        case "Sunny", "Clear":
            return "sun.max.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Cloudy":
            return "cloud.fill"
        default:
            return "cloud.sun.fill"
        }
    }
}
