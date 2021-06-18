//
//  WeatherInfo.swift
//  Callback Study
//
//  Created by Caio Fernandes on 17/06/21.
//

import Foundation

// MARK: - Welcome
struct WeatherInfo: Codable {
    let consolidatedWeather: [ConsolidatedWeather]

    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
    }
}

// MARK: - ConsolidatedWeather
struct ConsolidatedWeather: Codable {
    let weatherStateName: String
    let minTemp, maxTemp, theTemp, windSpeed: Double
    let windDirection, airPressure: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case weatherStateName = "weather_state_name"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity
    }
}
