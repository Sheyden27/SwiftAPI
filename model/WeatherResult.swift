import Foundation

struct WeatherResult: Decodable {
    let latitude: Double
    let longitude: Double
    let hourly: [HourlyData]
    let timezone: String

    struct HourlyData: Decodable {
        let temperature2m: Double
        let relativeHumidity2m: Double
        let apparentTemperature: Double
        let precipitationProbability: Double
        let rain: Double
        let weatherCode: Int
        let surfacePressure: Double
        let visibility: Double
        let windSpeed10m: Double
        let windDirection10m: Double

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case relativeHumidity2m = "relativehumidity_2m"
            case apparentTemperature
            case precipitationProbability
            case rain
            case weatherCode
            case surfacePressure
            case visibility
            case windSpeed10m
            case windDirection10m
        }
    }

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case hourly
        case timezone
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        hourly = try container.decode([HourlyData].self, forKey: .hourly)
        timezone = try container.decode(String.self, forKey: .timezone)
    }
}
