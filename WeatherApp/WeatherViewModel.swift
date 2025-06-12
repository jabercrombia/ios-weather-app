import Foundation

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: String
    let temperature: String
    let description: String
}

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var dailyForecasts: [DailyForecast] = []

    func fetchWeather(for city: String) {
        let apiKey = "f0b69f87ed2b40b5a21d41a0a78f413a"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=imperial"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode(ForecastResponse.self, from: data)

                DispatchQueue.main.async {
                    self.cityName = response.city.name
                    self.dailyForecasts = self.extractDailyForecasts(from: response.list)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    private func extractDailyForecasts(from list: [ForecastEntry]) -> [DailyForecast] {
        var grouped = Dictionary(grouping: list) { entry -> String in
            let date = Date(timeIntervalSince1970: entry.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }

        var results: [DailyForecast] = []

        let sortedKeys = grouped.keys.sorted()
        for key in sortedKeys {
            if let dayEntries = grouped[key], let first = dayEntries.first {
                let date = Date(timeIntervalSince1970: first.dt)
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, MMM d"
                let dateString = formatter.string(from: date)

                let forecast = DailyForecast(
                    date: dateString,
                    temperature: "\(Int(first.main.temp))°F",
                    description: first.weather.first?.description.capitalized ?? ""
                )
                results.append(forecast)
            }
        }

        return results
    }
}
