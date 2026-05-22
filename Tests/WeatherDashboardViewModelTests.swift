import Combine
import XCTest
@testable import WeatherTV

@MainActor
final class WeatherDashboardViewModelTests: XCTestCase {
    func testLoadForecastsSuccessTransitionsToLoaded() async throws {
        let viewModel = makeViewModel(
            weatherService: MockWeatherService(scenario: .success)
        )
        var states: [DashboardState] = []
        let cancellable = viewModel.$state.dropFirst().sink { states.append($0) }
        defer { cancellable.cancel() }

        await viewModel.loadForecasts()

        XCTAssertEqual(states.first, .loading)
        guard case .loaded(let rows) = states.last else {
            return XCTFail("Expected loaded state.")
        }
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows.first?.title, "Test City")
        XCTAssertFalse(rows.first?.forecasts.isEmpty ?? true)
    }

    func testLoadForecastsEmptyResponseTransitionsToEmpty() async {
        let viewModel = makeViewModel(
            weatherService: MockWeatherService(scenario: .empty)
        )
        var states: [DashboardState] = []
        let cancellable = viewModel.$state.dropFirst().sink { states.append($0) }
        defer { cancellable.cancel() }

        await viewModel.loadForecasts()

        XCTAssertEqual(states.first, .loading)
        XCTAssertEqual(states.last, .empty)
    }

    func testLoadForecastsFailureTransitionsToFailed() async {
        let viewModel = makeViewModel(
            weatherService: MockWeatherService(scenario: .failure)
        )
        var states: [DashboardState] = []
        let cancellable = viewModel.$state.dropFirst().sink { states.append($0) }
        defer { cancellable.cancel() }

        await viewModel.loadForecasts()

        XCTAssertEqual(states.first, .loading)
        guard case .failed(let errorViewState) = states.last else {
            return XCTFail("Expected failed state.")
        }
        XCTAssertEqual(errorViewState.title, L10n.Error.forecastUnavailableTitle)
        XCTAssertFalse(errorViewState.message.isEmpty)
    }

    func testRetryTransitionsThroughLoadingAndRecoversFromFailure() async {
        let service = MockWeatherService(scenarios: [.failure, .success])
        let viewModel = makeViewModel(weatherService: service)
        var states: [DashboardState] = []
        let cancellable = viewModel.$state.dropFirst().sink { states.append($0) }
        defer { cancellable.cancel() }

        await viewModel.loadForecasts()
        guard case .failed = states.last else {
            return XCTFail("Expected first request to fail.")
        }

        states.removeAll()
        await viewModel.retry()

        XCTAssertEqual(states.first, .loading)
        guard case .loaded(let rows) = states.last else {
            return XCTFail("Expected retry to recover.")
        }
        XCTAssertEqual(rows.count, 1)
    }

    private func makeViewModel(
        weatherService: WeatherServiceProtocol
    ) -> WeatherDashboardViewModel {
        WeatherDashboardViewModel(
            weatherService: weatherService,
            locations: [
                Location(
                    name: "Test City",
                    country: "Test Country",
                    latitude: 1,
                    longitude: 2
                )
            ]
        )
    }
}
