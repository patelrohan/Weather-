//
//  CurrentWeather.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import UIKit

/*! A model class that stores the details for Transactions. */

class CurrentWeather: NSObject {

    var apparentTemperature: Double?
    var currentSummary: String?
    var humidity: Double?
    var icon: String? 
    var minutelySummary: String?
    var temperature: Double?
    var time: String?
    var uvIndex : Double?
    var visibility: Double?
}
