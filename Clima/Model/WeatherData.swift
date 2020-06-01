//
//  WeatherData.swift
//  Clima
//
//  Created by Arthur Duver on 29/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
	var name: String
	let main: Main
	let weather: [Weather]
}

struct Main: Decodable {
	let temp: Double
}

struct Weather: Decodable {
	let id: Int
	let description: String
}
