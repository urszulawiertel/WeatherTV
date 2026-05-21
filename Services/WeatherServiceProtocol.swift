import Foundation

protocol WeatherServiceProtocol {
    func fetchForecast(for location: Location) async throws -> [DailyForecast]
}
