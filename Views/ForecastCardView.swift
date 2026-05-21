import SwiftUI

struct ForecastCardView: View {
    let forecast: DailyForecast

    @FocusState private var isFocused: Bool

    private enum Layout {
        static let cardWidth: CGFloat = 320
        static let cardHeight: CGFloat = 300
        static let cornerRadius: CGFloat = 12
        static let focusedScale = 1.1
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text(Self.dayFormatter.string(from: forecast.date))
                .font(.title3.weight(.semibold))

            Image(systemName: symbolName(for: forecast.condition))
                .font(.system(size: 74, weight: .medium))
                .frame(height: 82, alignment: .center)

            Spacer(minLength: 4)

            VStack(alignment: .leading, spacing: 12) {
                Text(forecast.condition)
                    .font(.title3.weight(.medium))
                    .lineLimit(2)
                    .minimumScaleFactor(0.86)
                    .frame(height: 58, alignment: .bottomLeading)

                Text("\(forecast.highTemperature)° / \(forecast.lowTemperature)°")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
                    .frame(height: 48, alignment: .bottomLeading)
            }
        }
        .foregroundStyle(.white)
        .padding(32)
        .frame(width: Layout.cardWidth, height: Layout.cardHeight, alignment: .leading)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(isFocused ? .white.opacity(0.58) : .white.opacity(0.18), lineWidth: isFocused ? 2 : 1)
        }
        .shadow(color: .black.opacity(isFocused ? 0.52 : 0.24), radius: isFocused ? 34 : 14, x: 0, y: isFocused ? 24 : 10)
        .shadow(color: .white.opacity(isFocused ? 0.24 : 0), radius: isFocused ? 22 : 0, x: 0, y: 0)
        .scaleEffect(isFocused ? Layout.focusedScale : 1)
        .zIndex(isFocused ? 1 : 0)
        .animation(.spring(response: 0.28, dampingFraction: 0.82), value: isFocused)
        .focusable(true)
        .focused($isFocused)
    }

    private var cardBackground: Color {
        isFocused ? .white.opacity(0.2) : .white.opacity(0.12)
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
