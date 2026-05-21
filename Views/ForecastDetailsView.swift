import SwiftUI

struct ForecastDetailsView: View {
    let forecast: DailyForecast

    var body: some View {
        VStack(spacing: 16) {
            Text("Forecast Details")
                .font(.title.bold())

            Text(forecast.condition)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.black))
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(forecast: DailyForecast.placeholder[0])
    }
}
