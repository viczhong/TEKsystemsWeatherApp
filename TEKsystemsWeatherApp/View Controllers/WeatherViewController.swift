//
//  WeatherViewController.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    // MARK: Properties and Outlets
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

    func getWeather(for location: String) {
        APIRequestManager.manager.getData(endPoint: "http://api.openweathermap.org/data/2.5/weather?q=\(location)&APPID=2f3672aee225fe4d6e25f0a1c81f655d") { (data) in
            if let _ = data {
                print("ok")
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destination as! SettingsViewController
            vc.delegate = self
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
    }
}
