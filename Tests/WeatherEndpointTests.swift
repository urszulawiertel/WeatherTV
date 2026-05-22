import XCTest
@testable import WeatherTV

final class WeatherEndpointTests: XCTestCase {
    func testURLContainsExpectedQueryItems() throws {
        let endpoint = WeatherEndpoint(latitude: 51.2465, longitude: 22.5684)

        let url = try XCTUnwrap(endpoint.url)
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = Dictionary(
            uniqueKeysWithValues: try XCTUnwrap(components.queryItems).compactMap { item in
                item.value.map { value in
                    (item.name, value)
                }
            }
        )

        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "api.open-meteo.com")
        XCTAssertEqual(components.path, "/v1/forecast")
        XCTAssertEqual(queryItems["latitude"], "51.2465")
        XCTAssertEqual(queryItems["longitude"], "22.5684")
        XCTAssertEqual(queryItems["forecast_days"], "7")
        XCTAssertEqual(queryItems["timezone"], "auto")
        XCTAssertEqual(queryItems["temperature_unit"], "celsius")
        XCTAssertEqual(queryItems["wind_speed_unit"], "kmh")
        XCTAssertEqual(queryItems["precipitation_unit"], "mm")

        let dailyQueryValue = try XCTUnwrap(queryItems["daily"])
        let dailyFields = dailyQueryValue.split(separator: ",").map(String.init)
        XCTAssertTrue(dailyFields.contains("weather_code"))
        XCTAssertTrue(dailyFields.contains("temperature_2m_max"))
        XCTAssertTrue(dailyFields.contains("temperature_2m_min"))
        XCTAssertTrue(dailyFields.contains("precipitation_probability_max"))
        XCTAssertTrue(dailyFields.contains("wind_speed_10m_max"))
    }
}
