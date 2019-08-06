//
//  ResourceManager.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import Foundation
import CoreLocation

/* A signleton class */

class ResourceManager{
    
    var currentWeather = CurrentWeather()
    
    static let sharedManager = ResourceManager()
    
    private init(){

    }
    
    func setCurrentWeather(currentWeather: CurrentWeather){
        self.currentWeather = currentWeather
    }
}
