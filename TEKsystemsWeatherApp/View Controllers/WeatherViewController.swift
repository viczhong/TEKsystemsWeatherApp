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
    
    let userDefaults = UserDefaults.standard
    let segueIdentifier = "settingsSegue"
    
    // Possible defaults
    var location = "Brooklyn, NY"
    var weather: Weather?
    var tempScale = TempScale.fahrenheit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather(for: location)
    }
    
    func updateWeather() {
        if let weather = weather {
            self.title = weather.cityName
            self.location = weather.cityName
            self.weatherConditionLabel.text = weather.description

            let url = URL(string: "http://openweathermap.org/img/w/\(weather.icon).png")!
            weatherImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
    
    func getWeather(for location: String) {
        if let locationString = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/weather?q=\(locationString),us&APPID=2f3672aee225fe4d6e25f0a1c81f655d") { (data) in
                if let data = data, let weather = Weather.getWeather(from: data) {
                    self.weather = weather
                    DispatchQueue.main.async {
                        self.updateWeather()
                    }
                }
            }
        }
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

extension WeatherViewController: SettingsDelegate {
    func changeSettings(_ controller: SettingsViewController, _ location: String, _ scale: TempScale) {
        if self.location != location {
            self.location = location
            getWeather(for: self.location)
        }
        
        self.tempScale = scale

        controller.dismiss(animated: true, completion: nil)
    }
}
