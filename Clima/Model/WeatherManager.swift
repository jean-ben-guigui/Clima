//
//  weatherManager.swift
//  Clima
//
//  Created by Arthur Duver on 29/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
	func didFailedWithError(_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager {
	let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=e72ca729af228beabd5d20e3b7749713&units=metric"
	
	var delegate: WeatherManagerDelegate?
	
	func fetchWeather(cityName: String) {
		DispatchQueue.global(qos: .userInitiated).async {
			let urlString = "\(self.weatherUrl)&q=\(cityName)"
			self.performRequest(with: urlString)
		}
	}
	
	func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		DispatchQueue.global(qos: .userInitiated).async {
			let urlString = "\(self.weatherUrl)&lat=\(latitude)&lon=\(longitude)"
			self.performRequest(with: urlString)
		}
	}
	
	func performRequest(with urlString: String) {
		if let url = URL(string: urlString) {
			let urlSession = URLSession.init(configuration: .default)
			let task = urlSession.dataTask(with: url) { data, response, error in
				if let error = error {
					self.delegate?.didFailedWithError(self, error: error)
					return
				}
				if let data = data {
					if let weather = self.parseJSON(data) {
						self.delegate?.didUpdateWeather(self, weather: weather)
					}
				}
			}
			task.resume()
		}
	}
	
	func parseJSON(_ weatherData: Data) -> WeatherModel? {
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
			let id = decodedData.weather[0].id
			let temp = decodedData.main.temp
			let name = decodedData.name
			
			return WeatherModel(conditionId: id, city: name, temperature: temp)
		} catch {
			self.delegate?.didFailedWithError(self, error: error)
			return nil
		}
	}
}
