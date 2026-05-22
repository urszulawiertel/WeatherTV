import XCTest
@testable import WeatherTV

@MainActor
final class ErrorMappingTests: XCTestCase {
    func testWeatherAPIErrorKeepsReadableMessage() async {
        let viewModel = WeatherDashboardViewModel(
            weatherService: FailingWeatherService(error: WeatherAPIError.serverError),
            locations: [.testLocation]
        )

        await viewModel.loadForecasts()

        guard case .failed(let errorViewState) = viewModel.state else {
            return XCTFail("Expected failed state.")
        }
        XCTAssertEqual(
            errorViewState.message,
            "The weather service is temporarily unavailable."
        )
    }

    func testUnknownErrorUsesReadableFallbackMessage() async {
        let viewModel = WeatherDashboardViewModel(
            weatherService: FailingWeatherService(error: TestWeatherError()),
            locations: [.testLocation]
        )

        await viewModel.loadForecasts()

        guard case .failed(let errorViewState) = viewModel.state else {
            return XCTFail("Expected failed state.")
        }
        XCTAssertEqual(
            errorViewState.message,
            "The forecast could not be loaded. Please try again in a moment."
        )
        XCTAssertFalse(errorViewState.message.contains("TestWeatherError"))
        XCTAssertFalse(errorViewState.message.contains("error 0"))
    }
}

private struct FailingWeatherService: WeatherServiceProtocol {
    let error: Error

    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        throw error
    }
}

private struct TestWeatherError: Error {}

private extension Location {
    static let testLocation = Location(
        name: "Test City",
        country: "Test Country",
        latitude: 1,
        longitude: 2
    )
}
