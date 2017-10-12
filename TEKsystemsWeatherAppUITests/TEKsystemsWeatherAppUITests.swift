//
//  TEKsystemsWeatherAppUITests.swift
//  TEKsystemsWeatherAppUITests
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import XCTest
@testable import TEKsystemsWeatherApp

class TEKsystemsWeatherAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // In the interest of time, I wrote one quick run-through test
    func testQuickRunThrough() {
        // given - Main View
        let searchField = app.searchFields["City, State, and/or Zip Code"]

        // then
        searchField.tap()
        searchField.typeText("Newark, NJ")
        app/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()

        let newYorkNavBar = app.navigationBars["Newark"]
        newYorkNavBar.children(matching: .button).element.tap()

        // given - Settings
        let celLabel = app.staticTexts["Temperature Scale: Celsius"]
        let fahLabel = app.staticTexts["Temperature Scale: Fahrenheit"]

        let fahSegment = app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Fahrenheit"]/*[[".segmentedControls.buttons[\"Fahrenheit\"]",".buttons[\"Fahrenheit\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        let celSegment = app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Celcius"]/*[[".segmentedControls.buttons[\"Celcius\"]",".buttons[\"Celcius\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/

        // then
        if fahSegment.isSelected {
            XCTAssertTrue(fahLabel.exists)
            XCTAssertFalse(celLabel.exists)

            celSegment.tap()
            XCTAssertTrue(celLabel.exists)
            XCTAssertFalse(fahLabel.exists)
        } else if celSegment.isSelected {
            XCTAssertTrue(celLabel.exists)
            XCTAssertFalse(fahLabel.exists)

            fahSegment.tap()
            XCTAssertTrue(fahLabel.exists)
            XCTAssertFalse(celLabel.exists)
        }

        // check to see if location text field is updated with previous input
        let settingsLocationTextField = app.textFields["City, State, and/or Zip Code"]
        XCTAssertEqual(settingsLocationTextField.value as! String, "Newark")

        settingsLocationTextField.tap()
        settingsLocationTextField.typeText("Los Angeles")

        app.keyboards.buttons["Done"].tap()
        app.buttons["Done"].tap()

        // Make sure it says something else in the Nav Bar
        XCTAssertFalse(newYorkNavBar.exists)
        XCTAssertTrue(app.navigationBars["Los Angeles"].exists)
    }
    
}
