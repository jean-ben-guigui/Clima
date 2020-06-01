//
//  WeatherModel.swift
//  Clima
//
//  Created by Arthur Duver on 29/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
	let conditionId: Int
	let city: String
	let temperature: Double
	
	var stringTemperature: String {
		return String(format: "%.1f", temperature)
	}
	
	var conditionName: String {
		switch conditionId {
		case 200..<300:
			return "cloud.bolt"
		case 300..<400:
			return "cloud.drizzle"
		case 500..<600:
			return "cloud.rain"
		case 600..<700:
			return "cloud.snow"
		case 700..<800:
			return "smoke"
		case 800:
			return "sun.max"
		default:
			return "cloud"
		}
	}
}
