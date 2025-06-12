import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city = "San Francisco"

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter City", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Get Forecast") {
                    viewModel.fetchWeather(for: city)
                }

                if !viewModel.cityName.isEmpty {
                    Text(viewModel.cityName)
                        .font(.title)
                        .padding(.top)

                    List(viewModel.dailyForecasts) { forecast in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(forecast.date)
                                    .font(.headline)
                                Text(forecast.description)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(forecast.temperature)
                                .font(.title2)
                        }
                        .padding(.vertical, 8)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("5-Day Forecast")
        }
    }
}
