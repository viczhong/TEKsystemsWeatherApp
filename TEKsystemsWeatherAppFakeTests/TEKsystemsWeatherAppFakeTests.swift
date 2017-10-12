//
//  TEKsystemsWeatherAppFakeTests.swift
//  TEKsystemsWeatherAppFakeTests
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import XCTest
@testable import TEKsystemsWeatherApp

class TEKsystemsWeatherAppFakeTests: XCTestCase {
    var apiRequestManagerUnderTest: APIRequestManager!
    var weatherViewControllerUnderTest: WeatherViewController!

    override func setUp() {
        super.setUp()
        apiRequestManagerUnderTest = APIRequestManager()
        weatherViewControllerUnderTest = WeatherViewController()

        // Grabbing the local JSON file to use as data
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "weather", ofType: "json")

        // Turning the JSON into Data
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        // Spoofing the session
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=queens,ny,us&APPID=2f3672aee225fe4d6e25f0a1c81f655d")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        apiRequestManagerUnderTest.defaultSession = sessionMock
    }
    
    override func tearDown() {
        apiRequestManagerUnderTest = nil
        weatherViewControllerUnderTest = nil
        super.tearDown()
    }
    
    // Fake URLSession with DHURLSession protocol and stubs
    func test_GetWeather_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")

        // when
        XCTAssertNil(weatherViewControllerUnderTest.weather, "This shouldn't be anything yet")
        apiRequestManagerUnderTest.getData(endPoint: "queens") { (data, _) in
            if let data = data, let weather = Weather.getWeather(from: data) {
                self.weatherViewControllerUnderTest.weather = weather
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // then
        if let weather = weatherViewControllerUnderTest.weather {
            XCTAssertEqual(weather.cityName, "New York", "Didn't parse correctly")
            XCTAssertEqual(weatherViewControllerUnderTest.convertWeather(from: (weather.temp), to: TempScale.fahrenheit), 69, "Didn't convert correctly")
        } else {
            XCTFail("Weather couln't be unrwapped")
        }
    }
    
}
