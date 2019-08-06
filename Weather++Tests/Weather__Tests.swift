//
//  Weather__Tests.swift
//  Weather++Tests
//
//  Created by Rohan Patel on 7/23/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import XCTest
//import Utilities

@testable import Weather__

class Weather__Tests: XCTestCase {

    func testValidCelsiusToFahrenheitConversion(){
        let temperatureC = 40.0
        let temperatureF = 104.0
        
        XCTAssertEqual(Utilities.convertToFahrenheit(temperature: temperatureC), temperatureF)
    }

    func testValidFahrenheitToCelsiusConversion(){
        let temperatureC = 40.0
        let temperatureF = 104.0
        
        XCTAssertEqual(Utilities.convertToCelsius(temperature: temperatureF), temperatureC)
    }
    
    func testValidMilesToKmsConversion(){
        let distanceKms = 160.9
        let distanceMiles = 100.0

        XCTAssertEqual(Utilities.convertMilesToKms(miles: distanceMiles), distanceKms)
    }

    func testValidKmsToMilesConversion(){
        let distanceKms = 160.9
        let distanceMiles = 100.0
        
        XCTAssertEqual(Utilities.convertKmsToMiles(kms: distanceKms), distanceMiles)
    }
    

}
