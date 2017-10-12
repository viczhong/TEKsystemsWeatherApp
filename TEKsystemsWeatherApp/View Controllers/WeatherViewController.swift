//
//  WeatherViewController.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {
    // MARK: Properties and Outlets
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var tempScaleLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!

    let userDefaults = UserDefaults.standard
    let segueIdentifier = "settingsSegue"

    var location = "Brooklyn, NY"
    var weather: Weather?
    var tempScale = TempScale.fahrenheit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadDefaults()
        getWeather(location)
    }

    // MARK: Functions
    func convertWeather(from temp: Double, to tempScale: TempScale) -> Int {
        var temp = temp

        if tempScale == .celsius {
            temp -= 273.15
        } else {
            temp = temp * 9/5 - 459.67
        }

        return Int(temp)
    }

    func updateWeatherView() {
        if let weather = weather {
            self.title = weather.cityName
            self.location = weather.cityName
            self.degreesLabel.text = "\(convertWeather(from: weather.temp, to: tempScale))°"
            self.tempScaleLabel.text = tempScale.rawValue

            // Loving Swift 4's new multi-line strings
            self.weatherConditionLabel.text = """
            Right now, we've got \(weather.description).

            Low: \(convertWeather(from: weather.min, to: tempScale))°
            High: \(convertWeather(from: weather.max, to: tempScale))°
            """

            // In retrospect, we probably didn't need to use Kingfisher to cache these small images.
            let url = URL(string: "http://openweathermap.org/img/w/\(weather.icon).png")!
            weatherImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))

            // For retrival next time the app starts
            userDefaults.set(weather.cityName, forKey: "location")
        }
    }

    func loadDefaults() {
        if let defaultLocation = userDefaults.string(forKey: "location") {
            location = defaultLocation
        }

        if let previousTempScale = userDefaults.string(forKey: "tempScale") {
            if previousTempScale == TempScale.celsius.rawValue {
                tempScale = .celsius
            }
        }
    }
    
    func getWeather(_ location: String) {
        if let locationString = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/weather?q=\(locationString),us&APPID=2f3672aee225fe4d6e25f0a1c81f655d", callback: {(data, error) in

                if let _ = error {
                    self.connectionFailed()
                }

                if let data = data, let weather = Weather.getWeather(from: data) {
                    self.weather = weather
                    DispatchQueue.main.async {
                        self.updateWeatherView()
                    }
                }
            })
        }
    }

    func connectionFailed() {
        let alertController = UIAlertController(title: "Error", message: "Cannot get weather!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
            vc.locationString = location
            vc.tempScale = tempScale
        }
    }
}

// MARK: - Extensions
// I prefer just prefer delegation over notification
extension WeatherViewController: SettingsDelegate {
    func changeSettings(_ controller: SettingsViewController, _ location: String, _ scale: TempScale) {
        if self.location != location {
            self.location = location
            getWeather(self.location)
        }
        
        if self.tempScale != scale {
            self.tempScale = scale
            updateWeatherView()
            userDefaults.set(scale.rawValue, forKey: "tempScale")
        }

        controller.dismiss(animated: true, completion: nil)
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchLocation = searchBar.text {
            getWeather(searchLocation)
        }

        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
