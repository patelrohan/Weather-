//
//  Constants.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import Foundation

struct API {
    static let APIKey = "4b9283d6c56c63372e51228ba99f611b"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")
    
    static var URLWithAPIKey: URL{
        return (BaseURL?.appendingPathComponent(APIKey+"/"))!
    }
}

