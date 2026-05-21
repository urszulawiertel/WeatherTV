import SwiftUI

struct WeatherDashboardView: View {
    @StateObject private var viewModel: WeatherDashboardViewModel

    init(viewModel: WeatherDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 44) {
                header

                ForEach(viewModel.locationForecasts) { rowViewModel in
                    LocationForecastRowView(viewModel: rowViewModel)
                }
            }
            .padding(.horizontal, 72)
            .padding(.vertical, 56)
        }
        .background(Color(.black))
        .task {
            await viewModel.loadForecasts()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("WeatherTV")
                .font(.largeTitle.bold())

            Text("Multi-day forecast")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

struct WeatherDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDashboardView(
            viewModel: WeatherDashboardViewModel(
                weatherService: MockWeatherService()
            )
        )
    }
}
