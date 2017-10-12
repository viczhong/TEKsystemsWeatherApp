//
//  TEKsystemsWeatherAppNetworkingTests.swift
//  TEKsystemsWeatherAppNetworkingTests
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import XCTest
@testable import TEKsystemsWeatherApp

class TEKsystemsWeatherAppNetworkingTests: XCTestCase {
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = .shared
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: faster fail
    func testCallToOpenWeatherAPICompletes() {
        // given
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Brooklyn,ny,us&APPID=2f3672aee225fe4d6e25f0a1c81f655d")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { (_, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }

        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
