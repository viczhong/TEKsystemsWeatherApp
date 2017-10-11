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
    let id: Int = 0

    init() {}
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

