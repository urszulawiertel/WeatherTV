import SwiftUI

struct LocationForecastRowView: View {
    let viewModel: LocationForecastViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.title)
                    .font(.title.bold())

                Text(viewModel.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 38) {
                    ForEach(viewModel.forecasts) { forecast in
                        ForecastCardView(forecast: forecast)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 44)
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
