import SwiftUI

struct LocationForecastRowView: View {
    let viewModel: LocationForecastViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.title)
                    .font(.title2.bold())

                Text(viewModel.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(viewModel.forecasts) { forecast in
                        ForecastCardView(forecast: forecast)
                    }
                }
                .padding(.vertical, 12)
            }
        }
    }
}

struct LocationForecastRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationForecastRowView(
            viewModel: LocationForecastViewModel(
                location: .predefined[0],
                forecasts: DailyForecast.placeholder
            )
        )
    }
}
