import Foundation

struct DailyForecast: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int

    init(
        id: UUID = UUID(),
        date: Date,
        condition: String,
        highTemperature: Int,
        lowTemperature: Int
    ) {
        self.id = id
        self.date = date
        self.condition = condition
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
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
                highTemperature: 18 + offset,
                lowTemperature: 9 + offset
            )
        }
    }()
}
