//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	var weatherManager = WeatherManager()
	let locationManager = CoreLocation.CLLocationManager()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		searchTextField.delegate = self
		weatherManager.delegate = self
		locationManager.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		if CLLocationManager.significantLocationChangeMonitoringAvailable() {
			self.locationManager.requestLocation()
		}
    }
	
	@IBAction func currentLocationPressed(_ sender: UIButton) {
		if CLLocationManager.significantLocationChangeMonitoringAvailable() {
			self.locationManager.requestLocation()
		}
	}

}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	
	@IBAction func searchPressed(_ sender: Any) {
		print(searchTextField.text!)
		searchTextField.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print(textField.text!)
		textField.endEditing(true)
		return true
	}
	
	func  textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "Type something"
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if let city = textField.text {
			weatherManager.fetchWeather(cityName: city)
		}
		
		textField.text = ""
	}
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else {
				return
			}
			self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
			self.temperatureLabel.text = weather.stringTemperature
			self.cityLabel.text = weather.city
		}
	}
	
	func didFailedWithError(_ weatherManager: WeatherManager, error: Error) {
		print(error)
	}
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("bien")
		if let location = locations.last {
			locationManager.stopUpdatingLocation()
			let lat = location.coordinate.latitude
			let long = location.coordinate.longitude
			weatherManager.fetchWeather(latitude: lat, longitude: long)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error \(error)")
	}
}
