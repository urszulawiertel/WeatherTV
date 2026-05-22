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

            VStack(alignment: .leading, spacing: 64) {
                header
                forecastOverview
                metricsGrid
            }
            .padding(.horizontal, 116)
            .padding(.vertical, 80)
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
        VStack(alignment: .leading, spacing: 16) {
            Text(locationName)
                .font(.system(size: 58, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Text(Self.fullDateFormatter.string(from: forecast.date))
                .font(.title.bold())
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
    }

    var forecastOverview: some View {
        HStack(alignment: .center, spacing: 56) {
            Image(systemName: forecast.iconName)
                .font(.system(size: 132, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white)
                .frame(width: 160, height: 160)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 18) {
                Text(forecast.condition)
                    .font(.system(size: 52, weight: .semibold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                Text(temperatureRangeText)
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }

    var metricsGrid: some View {
        HStack(spacing: 28) {
            DetailMetricView(
                title: "High",
                value: "\(forecast.highTemperature)°",
                systemImageName: "thermometer.sun.fill"
            )

            DetailMetricView(
                title: "Low",
                value: "\(forecast.lowTemperature)°",
                systemImageName: "thermometer.snowflake"
            )

            if let precipitationProbability = forecast.precipitationProbability {
                DetailMetricView(
                    title: "Precipitation",
                    value: "\(precipitationProbability)%",
                    systemImageName: "drop.fill"
                )
            }

            if let windSpeed = forecast.windSpeed {
                DetailMetricView(
                    title: "Wind",
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
        "\(Int(windSpeed.rounded())) km/h"
    }
}

// MARK: - Supporting Views

private struct DetailMetricView: View {
    let title: String
    let value: String
    let systemImageName: String

    private enum Layout {
        static let cardWidth: CGFloat = 300
        static let cardHeight: CGFloat = 190
        static let cornerRadius: CGFloat = 12
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: systemImageName)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 46, height: 46, alignment: .leading)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Text(value)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
            }
        }
        .foregroundStyle(.white)
        .padding(28)
        .frame(width: Layout.cardWidth, height: Layout.cardHeight, alignment: .leading)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        }
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
