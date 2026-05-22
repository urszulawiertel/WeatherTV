import XCTest
@testable import WeatherTV

final class LocalizationTests: XCTestCase {
    func testPolishWeatherServiceUnavailableMessageIsLocalized() throws {
        XCTAssertEqual(
            try localizedString(forKey: "error.weather.serverError", language: "pl"),
            "Usługa pogodowa jest tymczasowo niedostępna."
        )
    }

    func testCriticalLocalizedStringsResolveForSupportedLanguages() throws {
        let criticalKeys = [
            "error.weather.serverError",
            "error.weather.invalidResponse",
            "error.forecastLoadFailed.message",
            "dashboard.retry.button"
        ]

        for language in ["en", "pl"] {
            for key in criticalKeys {
                let value = try localizedString(forKey: key, language: language)

                XCTAssertFalse(value.isEmpty)
                XCTAssertNotEqual(value, key)
            }
        }
    }

    func testRequiredUserFacingKeysArePresent() throws {
        let requiredKeys: Set<String> = [
            "dashboard.loading.title",
            "dashboard.loading.message",
            "dashboard.empty.title",
            "dashboard.empty.message",
            "dashboard.retry.button",
            "dashboard.subtitle",
            "forecast.details.high",
            "forecast.details.low",
            "forecast.details.precipitation",
            "forecast.details.wind",
            "error.forecastUnavailable.title",
            "error.forecastLoadFailed.message",
            "error.weather.invalidURL",
            "error.weather.invalidResponse",
            "error.weather.decodingFailed",
            "error.weather.serverError",
            "error.weather.unknown"
        ]

        for language in ["en", "pl"] {
            let keys = try localizationKeys(for: language)

            XCTAssertTrue(requiredKeys.isSubset(of: keys))
        }
    }

    func testUsedErrorKeysResolveForSupportedLanguages() throws {
        let errorKeys = [
            "error.forecastUnavailable.title",
            "error.forecastLoadFailed.message",
            "error.weather.invalidURL",
            "error.weather.invalidResponse",
            "error.weather.decodingFailed",
            "error.weather.serverError",
            "error.weather.unknown"
        ]

        for language in ["en", "pl"] {
            for key in errorKeys {
                let value = try localizedString(forKey: key, language: language)

                XCTAssertFalse(value.isEmpty)
                XCTAssertNotEqual(value, key)
            }
        }
    }

    private func localizedString(
        forKey key: String,
        language: String
    ) throws -> String {
        let bundle = try localizedBundle(for: language)
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    private func localizationKeys(for language: String) throws -> Set<String> {
        let bundle = try localizedBundle(for: language)
        let path = try XCTUnwrap(
            bundle.path(forResource: "Localizable", ofType: "strings")
        )
        let strings = try XCTUnwrap(
            NSDictionary(contentsOfFile: path) as? [String: String]
        )

        return Set(strings.keys)
    }

    private func localizedBundle(for language: String) throws -> Bundle {
        let path = try XCTUnwrap(
            Bundle.main.path(forResource: language, ofType: "lproj")
        )
        return try XCTUnwrap(Bundle(path: path))
    }
}
