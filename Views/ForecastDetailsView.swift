import SwiftUI

struct ForecastDetailsView: View {
    let locationName: String
    let forecast: DailyForecast

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    var body: some View {
        ZStack {
            background

            VStack(alignment: .leading, spacing: 44) {
                header
                forecastOverview
                metricsGrid
            }
            .padding(.horizontal, 116)
            .padding(.top, 58)
            .padding(.bottom, 72)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

// MARK: - Layout

private extension ForecastDetailsView {
    var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.06, blue: 0.08),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(locationName)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Text(Self.fullDateFormatter.string(from: forecast.date))
                .font(.title2.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
    }

    var forecastOverview: some View {
        HStack(alignment: .center, spacing: 46) {
            Image(systemName: forecast.iconName)
                .font(.system(size: 120, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white)
                .frame(width: 144, height: 144)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 14) {
                Text(forecast.condition)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                Text(temperatureRangeText)
                    .font(.system(size: 68, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }

    var metricsGrid: some View {
        HStack(spacing: 30) {
            DetailMetricView(
                title: L10n.ForecastDetails.high,
                value: "\(forecast.highTemperature)°",
                systemImageName: "thermometer.sun.fill"
            )

            DetailMetricView(
                title: L10n.ForecastDetails.low,
                value: "\(forecast.lowTemperature)°",
                systemImageName: "thermometer.snowflake"
            )

            if let precipitationProbability = forecast.precipitationProbability {
                DetailMetricView(
                    title: L10n.ForecastDetails.precipitation,
                    value: "\(precipitationProbability)%",
                    systemImageName: "drop.fill"
                )
            }

            if let windSpeed = forecast.windSpeed {
                DetailMetricView(
                    title: L10n.ForecastDetails.wind,
                    value: formattedWindSpeed(windSpeed),
                    systemImageName: "wind"
                )
            }
        }
    }

    var temperatureRangeText: String {
        "\(forecast.highTemperature)° / \(forecast.lowTemperature)°"
    }

    func formattedWindSpeed(_ windSpeed: Double) -> String {
        L10n.ForecastDetails.windSpeed(Int(windSpeed.rounded()))
    }
}

// MARK: - Supporting Views

private struct DetailMetricView: View {
    let title: String
    let value: String
    let systemImageName: String

    private enum Layout {
        static let cardWidth: CGFloat = 340
        static let cardHeight: CGFloat = 190
        static let cornerRadius: CGFloat = 12
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImageName)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 34, height: 34, alignment: .leading)
                .accessibilityHidden(true)

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.92)

            Text(value)
                .font(.system(size: 46, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 30)
        .padding(.vertical, 26)
        .frame(width: Layout.cardWidth, height: Layout.cardHeight, alignment: .leading)
        .background(metricBackground, in: RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        }
    }

    private var metricBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.11),
                Color.white.opacity(0.06)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(
            locationName: "Lublin",
            forecast: DailyForecast.placeholder[0]
        )
    }
}
