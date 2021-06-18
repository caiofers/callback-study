//
//  WeatherLocation.swift
//  Callback Study
//
//  Created by Caio Fernandes on 17/06/21.
//

import Foundation

// MARK: - WelcomeElement
struct WeatherLocation: Codable {
    let title: String
    let woeid: Int

    enum CodingKeys: String, CodingKey {
        case title
        case woeid
    }
}

typealias WeatherLocations = [WeatherLocation]
