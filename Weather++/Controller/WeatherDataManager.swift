//
//  WeatherDataManager.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import Foundation

/* A helper class to facilitate parsing of API response and storing data into model object */


class WeatherDataManager {
    
    class func getLatestWeatherData(completion: @escaping () -> ()){
        
        let lat = UserDefaults.standard.double(forKey: "latitude")
        let long = UserDefaults.standard.double(forKey: "longitude")
        
        WebServiceManager.fetchWeatherDataForLocation(latitude: lat,
                                                      longitude: long,
                                                      success: { (response) in
                                                        if let value = response as? [String : Any]{
                                                            
                                                            let currentWeather = CurrentWeather()
                                                            
                                                            if let currently = value["currently"] as? [String: Any]{
                                                                
                                                                currentWeather.apparentTemperature = currently["apparentTemperature"] as? Double
                                                                currentWeather.currentSummary = currently["summary"] as? String
                                                                currentWeather.humidity = currently["humidity"] as? Double
                                                                currentWeather.icon = currently["icon"] as? String
                                                                currentWeather.temperature = currently["temperature"] as? Double
                                                                currentWeather.time = convertTime(time: currently["time"] as? Double)
                                                                currentWeather.uvIndex = currently["uvIndex"] as? Double
                                                                currentWeather.visibility = currently["visibility"] as? Double
                                                            }
                                                            
                                                            if let minutely = value["minutely"] as? [String: Any]{
                                                                currentWeather.minutelySummary = minutely["summary"] as? String
                                                            }
                                                            
                                                            ResourceManager.sharedManager.currentWeather = currentWeather
                                                            completion()
                                                        }
        }) { (error) in
            
        }
        
    }
    
    /**
     *  Type fucntion to convert the UNIX time into human readable format.
     *
     *  @param time   A double type value containing UNIX time
     *
     *  @return A string representing the time
     */
    class func convertTime(time : Double?) -> String {
        
        if let time = time{
            let date = Date(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
            
        else{
            return "time not available"
        }
    }
}
