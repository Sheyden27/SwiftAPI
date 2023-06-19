import SwiftUI

struct WeatherService {
    struct InvalidURLError: Error {}
    func searchCity(cityName: String) async -> [Float] {
        let urlCity = "https://geocoding-api.open-meteo.com/v1/search?name=\(cityName)"
        let sessionCity = URLSession.shared
        let (data, _) = try await sessionCity.data(from: urlCity)
                
        let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        let coords: [Float]
        if let json = object {
            let results = json["results"] as? [[String: Any]]
            if let results = results {
                print(results[0]["latitude"])
                print(results[0]["longitude"])
                coords[0] = results[0]["latitude"]
                coords[1] = results[0]["longitude"]
            }
        }

        return coords
    }
    

    func searchWeather(city: String) async throws {
        // remplacer latitude & longitude par coords de searchCity
        let coords = searchCity("Versailles")
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=48.80&longitude=2.13&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,rain,weathercode,surface_pressure,visibility,windspeed_10m,winddirection_10m&timezone=Europe%2FLondon")
        guard let url = url else {
            throw InvalidURLError()
        }
        
        do {
            let session = URLSession.shared
            let (data, _) = try await session.data(from: url)
            
            let results = try JSONDecoder().decode(WeatherResult.self, from: data)
            print(results.hourly[0])
        } catch {
            print(error.localizedDescription)
        }
    }
}

@MainActor
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            print("In task")
            do {
                try await WeatherService().searchWeather(city: "Versailles")
            } catch {
                print(error)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}