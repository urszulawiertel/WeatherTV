import SwiftUI

struct ForecastCardView: View {
    let forecast: DailyForecast
    let isFocused: Bool

    private enum Layout {
        static let cardWidth: CGFloat = 336
        static let cardHeight: CGFloat = 324
        static let cornerRadius: CGFloat = 12
        static let focusedScale = 1.06
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var body: some View {
        cardContent
        .foregroundStyle(.white)
        .padding(32)
        .frame(width: Layout.cardWidth, height: Layout.cardHeight, alignment: .leading)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(
                    isFocused ? .white.opacity(0.34) : .white.opacity(0.16),
                    lineWidth: isFocused ? 2 : 1
                )
        }
        .shadow(
            color: .black.opacity(isFocused ? 0.68 : 0.28),
            radius: isFocused ? 36 : 14,
            x: 0,
            y: isFocused ? 24 : 10
        )
        .shadow(
            color: .blue.opacity(isFocused ? 0.18 : 0),
            radius: isFocused ? 24 : 0,
            x: 0,
            y: 0
        )
        .scaleEffect(isFocused ? Layout.focusedScale : 1)
        .zIndex(isFocused ? 1 : 0)
        .animation(.spring(response: 0.28, dampingFraction: 0.82), value: isFocused)
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            dayLabel
            weatherIcon
            Spacer(minLength: 0)
            weatherSummary
        }
    }

    private var dayLabel: some View {
        Text(Self.dayFormatter.string(from: forecast.date))
            .font(.title3.weight(.semibold))
            .lineLimit(1)
    }

    private var weatherIcon: some View {
        Image(systemName: forecast.iconName)
            .font(.system(size: 72, weight: .medium))
            .frame(height: 78, alignment: .center)
            .accessibilityHidden(true)
    }

    private var weatherSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(forecast.condition)
                .font(.title3.weight(.medium))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .frame(minHeight: 62, alignment: .bottomLeading)

            Text("\(forecast.highTemperature)° / \(forecast.lowTemperature)°")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .frame(minHeight: 48, alignment: .bottomLeading)
        }
    }

    private var cardBackground: LinearGradient {
        LinearGradient(
            colors: cardBackgroundColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var cardBackgroundColors: [Color] {
        if isFocused {
            return [
                Color(red: 0.13, green: 0.16, blue: 0.2),
                Color(red: 0.06, green: 0.08, blue: 0.11)
            ]
        }

        return [
            Color.white.opacity(0.1),
            Color.white.opacity(0.06)
        ]
    }
}

struct ForecastCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastCardView(
            forecast: DailyForecast.placeholder[0],
            isFocused: true
        )
    }
}
