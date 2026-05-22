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
            L10n.Error.serverError
        )
    }

    func testWeatherAPIErrorsUseLocalizedUserFacingMessages() {
        let expectedMessages: [WeatherAPIError: String] = [
            .invalidURL: L10n.Error.invalidURL,
            .invalidResponse: L10n.Error.invalidResponse,
            .decodingFailed: L10n.Error.decodingFailed,
            .serverError: L10n.Error.serverError,
            .unknown: L10n.Error.unknown
        ]

        for (error, message) in expectedMessages {
            XCTAssertEqual(error.errorDescription, message)
        }
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
            L10n.Error.forecastLoadFailedMessage
        )
        XCTAssertFalse(errorViewState.message.contains("TestWeatherError"))
        XCTAssertFalse(errorViewState.message.contains("error 0"))
    }

    func testTechnicalLocalizedErrorUsesReadableFallbackMessage() async {
        let viewModel = WeatherDashboardViewModel(
            weatherService: FailingWeatherService(error: TestTechnicalError()),
            locations: [.testLocation]
        )

        await viewModel.loadForecasts()

        guard case .failed(let errorViewState) = viewModel.state else {
            return XCTFail("Expected failed state.")
        }
        XCTAssertEqual(errorViewState.message, L10n.Error.forecastLoadFailedMessage)
        XCTAssertFalse(errorViewState.message.contains("Database timeout"))
    }
}

private struct FailingWeatherService: WeatherServiceProtocol {
    let error: Error

    func fetchForecast(for location: Location) async throws -> [DailyForecast] {
        throw error
    }
}

private struct TestWeatherError: Error {}

private struct TestTechnicalError: LocalizedError {
    var errorDescription: String? {
        "Database timeout while reading cache."
    }
}

private extension Location {
    static let testLocation = Location(
        name: "Test City",
        country: "Test Country",
        latitude: 1,
        longitude: 2
    )
}
