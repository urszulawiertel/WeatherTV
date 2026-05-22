import SwiftUI

struct LocationForecastRowView: View {
    let viewModel: LocationForecastViewModel
    let onSelectForecast: (DailyForecast) -> Void

    @FocusState private var focusedForecastID: DailyForecast.ID?

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            rowHeader

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 38) {
                    ForEach(viewModel.forecasts) { forecast in
                        forecastButton(for: forecast)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 48)
            }
            .padding(.horizontal, -24)
        }
    }

    private var rowHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.title.bold())

            Text(viewModel.subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private func forecastButton(for forecast: DailyForecast) -> some View {
        Button {
            onSelectForecast(forecast)
        } label: {
            ForecastCardView(
                forecast: forecast,
                isFocused: focusedForecastID == forecast.id
            )
        }
        .buttonStyle(.plain)
        .focused($focusedForecastID, equals: forecast.id)
    }
}

struct LocationForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationForecastRowView(
            viewModel: LocationForecastViewModel(
                location: .predefined[0],
                forecasts: DailyForecast.placeholder
            ),
            onSelectForecast: { _ in }
        )
    }
}
