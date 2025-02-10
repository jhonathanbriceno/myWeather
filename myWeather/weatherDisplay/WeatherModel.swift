//
//  WeatherModel.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

struct Weather: Codable {
    var current: CurrentWeather?
    var location: Location?
    var error: WeatherError?
}

struct CurrentWeather: Codable {
    var temperature: Double
    var condition: WeatherCondition
    var humidity: Int
    var uvIndex: Double
    var feelsLike: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp_f"
        case condition
        case humidity
        case uvIndex = "uv"
        case feelsLike = "feelslike_f"
    }
}

struct WeatherCondition: Codable {
    var text: String
    var icon: String
}

struct Location: Codable {
    var name: String
}

struct WeatherError: Codable {
    var code: Int
    var message: String
}
