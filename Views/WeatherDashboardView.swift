import SwiftUI

struct WeatherDashboardView: View {
    @StateObject private var viewModel: WeatherDashboardViewModel

    init(viewModel: WeatherDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 72) {
                header

                ForEach(viewModel.locationForecasts) { rowViewModel in
                    LocationForecastRowView(viewModel: rowViewModel)
                }
            }
            .padding(.horizontal, 96)
            .padding(.top, 72)
            .padding(.bottom, 96)
        }
        .background(Color(.black))
        .task {
            await viewModel.loadForecasts()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WeatherTV")
                .font(.system(size: 56, weight: .bold, design: .rounded))

            Text("Multi-day forecast")
                .font(.title2)
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
