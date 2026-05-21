import SwiftUI

@main
struct WeatherTVApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherDashboardView(
                viewModel: WeatherDashboardViewModel(
                    weatherService: MockWeatherService()
                )
            )
        }
    }
}
