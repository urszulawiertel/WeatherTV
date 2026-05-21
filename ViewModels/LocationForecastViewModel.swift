import Foundation

struct LocationForecastViewModel: Identifiable {
    var id: Location.ID {
        location.id
    }

    let location: Location
    let forecasts: [DailyForecast]

    var title: String {
        location.name
    }

    var subtitle: String {
        location.country
    }
}
