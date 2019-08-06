//
//  WebServiceManager.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import Foundation
import Alamofire

/* A controller class responsible for handling all API calls*/

class WebServiceManager{

    /**
     *  Type method using closures which handles the 'HTTP GET' request web service calls using `Alamofire` to get the latest weather data for a given location.
     *
     *  @param latitude coordinate of a location
     *  @param longitude coordinate of a location
     *  @param success Success callback block
     *  @param failure Failure callback block
     */
    
    class func fetchWeatherDataForLocation(latitude: Double,
                                           longitude: Double,
                                           success: @escaping (Any?) -> Void,
                                           failure: @escaping (Error?) -> Void){
        
        let url = API.URLWithAPIKey.appendingPathComponent("\(latitude),\(longitude)")
        
        let parameters: Parameters = ["exclude" : "hourly, daily"]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching weather data")
                failure(response.result.error)
                return
            }
            
            if let json = response.result.value{
                success(json)
            }
            
        }
        
    }
    
}
