import SwiftUI

struct WeatherDashboardView: View {
    @StateObject private var viewModel: WeatherDashboardViewModel
    @State private var navigationPath = NavigationPath()

    init(viewModel: WeatherDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                content
            }
            .navigationDestination(for: ForecastDetailsRoute.self) { route in
                ForecastDetailsView(
                    locationName: route.locationName,
                    forecast: route.forecast
                )
            }
        }
        .task {
            await viewModel.loadForecasts()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            statusView(
                title: "Loading forecasts",
                message: "Getting the latest mock weather for your saved locations.",
                showsProgress: true
            )
        case .loaded(let locationForecasts):
            loadedView(locationForecasts)
        case .empty:
            statusView(
                title: "No forecasts available",
                message: "There is no mock forecast data to show right now.",
                showsProgress: false
            )
        case .failed(let errorViewState):
            errorView(errorViewState)
        }
    }

    private func loadedView(_ locationForecasts: [LocationForecastViewModel]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 72) {
                header

                ForEach(locationForecasts) { rowViewModel in
                    LocationForecastRowView(viewModel: rowViewModel) { forecast in
                        openDetails(
                            forecast: forecast,
                            locationName: rowViewModel.title
                        )
                    }
                }
            }
            .padding(.horizontal, 96)
            .padding(.top, 72)
            .padding(.bottom, 96)
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

    private func statusView(
        title: String,
        message: String,
        showsProgress: Bool
    ) -> some View {
        VStack(spacing: 28) {
            if showsProgress {
                ProgressView()
                    .controlSize(.large)
                    .scaleEffect(1.4)
            }

            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 46, weight: .bold, design: .rounded))

                Text(message)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 120)
    }

    private func errorView(_ errorViewState: ErrorViewState) -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text(errorViewState.title)
                    .font(.system(size: 46, weight: .bold, design: .rounded))

                Text(errorViewState.message)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    await viewModel.retry()
                }
            } label: {
                Text("Retry")
                    .font(.title3.bold())
                    .padding(.horizontal, 28)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 120)
    }

    private func openDetails(
        forecast: DailyForecast,
        locationName: String
    ) {
        navigationPath.append(
            ForecastDetailsRoute(
                locationName: locationName,
                forecast: forecast
            )
        )
    }
}

private struct ForecastDetailsRoute: Hashable {
    let locationName: String
    let forecast: DailyForecast
}

struct WeatherDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherDashboardView(
                viewModel: WeatherDashboardViewModel(
                    weatherService: MockWeatherService()
                )
            )

            WeatherDashboardView(
                viewModel: WeatherDashboardViewModel(
                    weatherService: MockWeatherService(scenario: .empty)
                )
            )

            WeatherDashboardView(
                viewModel: WeatherDashboardViewModel(
                    weatherService: MockWeatherService(scenario: .failure)
                )
            )
        }
    }
}
