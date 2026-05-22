import XCTest
@testable import WeatherTV

final class OpenMeteoForecastMapperTests: XCTestCase {
    func testMapDecodedResponseCreatesDailyForecast() throws {
        let data = try XCTUnwrap(sampleResponse.data(using: .utf8))
        let response = try JSONDecoder().decode(OpenMeteoForecastResponse.self, from: data)

        let forecasts = OpenMeteoForecastMapper.map(response)

        let forecast = try XCTUnwrap(forecasts.first)
        XCTAssertEqual(forecasts.count, 1)
        XCTAssertEqual(forecast.date, try expectedDate)
        XCTAssertEqual(forecast.condition, "Rain")
        XCTAssertEqual(forecast.iconName, "cloud.rain.fill")
        XCTAssertEqual(forecast.highTemperature, 22)
        XCTAssertEqual(forecast.lowTemperature, 13)
        XCTAssertEqual(forecast.precipitationProbability, 70)
        XCTAssertEqual(forecast.windSpeed, 15.4)
    }

    private var expectedDate: Date {
        get throws {
            var components = DateComponents()
            components.calendar = Calendar(identifier: .gregorian)
            components.timeZone = TimeZone(secondsFromGMT: 0)
            components.year = 2026
            components.month = 5
            components.day = 22
            return try XCTUnwrap(components.date)
        }
    }

    private var sampleResponse: String {
        """
        {
          "daily": {
            "time": ["2026-05-22"],
            "weather_code": [61],
            "temperature_2m_max": [21.6],
            "temperature_2m_min": [13.2],
            "precipitation_probability_max": [70],
            "wind_speed_10m_max": [15.4]
          }
        }
        """
    }
}
