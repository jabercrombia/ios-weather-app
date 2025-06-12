import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastEntry]
    let city: City
}

struct ForecastEntry: Codable {
    let main: Main
    let weather: [Weather]
    let dt: TimeInterval // For date/time info
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

struct City: Codable {
    let name: String
}
