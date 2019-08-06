//
//  Utilities.swift
//  Weather++
//
//  Created by Rohan Patel on 7/30/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import Foundation

class Utilities{
    
    /**
     *  Type fucntion to convert the temperature from Fahrenheit to Celsius
     *
     *  @param temperature  A `Double` type value containing temprature value in Fahrenheit
     *
     *  @return A `Double` type value containing temprature value in Celsius
     */
    
    class func convertToCelsius(temperature: Double) -> Double{
        return (temperature - 32) * 5 / 9
    }
    
    /**
     *  Type fucntion to convert the temperature from Celsius to Fahrenheit
     *
     *  @param temperature  A `Double` type value containing temprature value in Celsius
     *
     *  @return A `Double` type value containing temprature value in Fahrenheit
     */
    class func convertToFahrenheit(temperature: Double) -> Double{
        return (temperature * 9) / 5 + 32
    }
    
    /**
     *  Type fucntion to convert the distance from miles to kms
     *
     *  @param miles  A `Double` type value of a given distance in miles
     *
     *  @return A `Double` type value of a given distance in kms
     */
    class func convertMilesToKms(miles: Double) -> Double {
        return miles * 1.609
    }
    
    /**
     *  Type fucntion to convert the distance from kms to miles
     *
     *  @param miles  A `Double` type value of a given distance in kms
     *
     *  @return A `Double` type value of a given distance in miles
     */
    class func convertKmsToMiles(kms: Double) -> Double {
        return kms / 1.609
    }
    
}
