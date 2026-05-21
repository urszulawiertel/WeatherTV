import SwiftUI

struct ForecastCardView: View {
    let forecast: DailyForecast

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Self.dayFormatter.string(from: forecast.date))
                .font(.headline)

            Image(systemName: symbolName(for: forecast.condition))
                .font(.system(size: 52, weight: .medium))

            VStack(alignment: .leading, spacing: 6) {
                Text(forecast.condition)
                    .font(.callout)
                    .lineLimit(1)

                Text("\(forecast.highTemperature)° / \(forecast.lowTemperature)°")
                    .font(.title3.bold())
            }
        }
        .foregroundStyle(.white)
        .frame(width: 220, height: 190, alignment: .leading)
        .padding(24)
        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        }
        .focusable()
    }

    private func symbolName(for condition: String) -> String {
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

struct ForecastCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastCardView(forecast: DailyForecast.placeholder[0])
    }
}
