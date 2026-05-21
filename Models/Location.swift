import Foundation

struct Location: Identifiable, Hashable {
    let id: UUID
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    init(
        id: UUID = UUID(),
        name: String,
        country: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location {
    static let predefined: [Location] = [
        Location(name: "Lublin", country: "Poland", latitude: 51.2465, longitude: 22.5684),
        Location(name: "Warsaw", country: "Poland", latitude: 52.2297, longitude: 21.0122),
        Location(name: "London", country: "United Kingdom", latitude: 51.5072, longitude: -0.1276),
        Location(name: "Dubai", country: "UAE", latitude: 25.2048, longitude: 55.2708)
    ]
}
