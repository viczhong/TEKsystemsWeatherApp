//
//  Weather.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/10/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

enum WeatherModelParseError: Error {
    case results, parsing
}

class Weather {
    let cityName: String
    let id: Int
    let main: String
    let description: String
    let icon: String
    let temp: Double
    let min: Double
    let max: Double

    init(cityName: String, id: Int, main: String, description: String, icon: String, temp: Double, min: Double, max: Double) {
        self.cityName = cityName
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
        self.temp = temp
        self.min = min
        self.max = max
    }

    convenience init?(from dict: [String : Any]) throws {
        guard let cityName = dict["name"] as? String,
            let mainDict = dict["main"] as? [String : Any],
            let weather = dict["weather"] as? [AnyObject],
            let id = weather[0]["id"] as? Int,
            let main = weather[0]["main"] as? String,
            let description = weather[0]["description"] as? String,
            let icon = weather[0]["icon"] as? String,
            let temp = mainDict["temp"] as? Double,
            let min = mainDict["temp_min"] as? Double,
            let max = mainDict["temp_max"] as? Double else {
                throw WeatherModelParseError.parsing
        }

        self.init(cityName: cityName, id: id, main: main, description: description, icon: icon, temp: temp, min: min, max: max)
    }

    static func getWeather(from data: Data) -> Weather? {
        var weatherToReturn: Weather?

        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])

            guard let json = jsonData as? [String : Any] else {
                throw WeatherModelParseError.results
            }
            
            if let weather = try Weather(from: json) {
                weatherToReturn = weather
            }
        }

        catch {
            print("Error encountered with \(error)")
        }

        return weatherToReturn
    }
}

// http://api.openweathermap.org/data/2.5/weather?q=Brooklyn,ny,us&APPID=2f3672aee225fe4d6e25f0a1c81f655d
//{
//    "coord": {
//        "lon": -74.01,
//        "lat": 40.71
//    },
//    "weather": [
//    {
//    "id": 804,
//    "main": "Clouds",
//    "description": "overcast clouds",
//    "icon": "04d"
//    }
//    ],
//    "base": "stations",
//    "main": {
//        "temp": 295.4,
//        "pressure": 1019,
//        "humidity": 60,
//        "temp_min": 294.15,
//        "temp_max": 296.15
//    },
//    "visibility": 16093,
//    "wind": {
//        "speed": 4.6,
//        "deg": 140
//    },
//    "clouds": {
//        "all": 90
//    },
//    "dt": 1507752900,
//    "sys": {
//        "type": 1,
//        "id": 1969,
//        "message": 0.0047,
//        "country": "US",
//        "sunrise": 1507719844,
//        "sunset": 1507760413
//    },
//    "id": 5128581,
//    "name": "New York",
//    "cod": 200
//}

