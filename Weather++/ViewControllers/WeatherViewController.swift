//
//  ViewController.swift
//  Weather++
//
//  Created by Rohan Patel on 7/23/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var celsiusBtn: UIButton!
    @IBOutlet weak var fahrenheitBtn: UIButton!
    
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    
    @IBOutlet weak var currentTemperatureLbl: UILabel!
    @IBOutlet weak var currentWeatherSummaryLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var lastUpdatedLbl: UILabel!
    @IBOutlet weak var nextHourSummaryTextView: UITextView!
    @IBOutlet weak var selectedCityLbl: UILabel!
    @IBOutlet weak var uvIndexLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        addNotificationObervers()
        
        getLatestWeatherData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /**
     *  Adds Notification Observers
     */
    fileprivate func addNotificationObervers(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    /**
     *  Gets called by Observers when application prepares to enter foreground state
     *
     *  @param notification Notification object
     */
    @objc func applicationWillEnterForeground(notification: Notification){
        getLatestWeatherData()
    }
    
    /**
     *  Start Activity Indicator
     */
    fileprivate func startIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    /**
     *  Calls type method `getLatestWeatherData` of `WeatherDataManager` class to get
     *  latest weather data
     */
    func getLatestWeatherData(){
        startIndicator()
        WeatherDataManager.getLatestWeatherData {
            self.updateWeatherUI()
        }
    }
    
    /**
     *  Determines whether the current location saved by user is in the country
     *  adopting imperial unit system
     *
     *  @return A boolean value indicating whether current country saved by user
     *          uses Imperial unit system
     */
    func isCountryUsingImperialSystem() -> Bool {
        
        var result = false
        if let country = UserDefaults.standard.string(forKey: "country"){
            if (country == "USA" || country == "usa" ||
                country == "United States" || country == "United States of America"){
                result = true
            }
        }
        return result
    }
    
    /**
     *  Gets called to update UI elements representing weather data in Imperial units
     */
    func updateUIForImperialUnits(){
        
        let currentWeather = ResourceManager.sharedManager.currentWeather
        
        let isDataInImperial = isCountryUsingImperialSystem() // if true data from web service is already in imperial
        
        if var currentTemperature = currentWeather.temperature{
            currentTemperature = isDataInImperial ? currentTemperature : Utilities.convertToFahrenheit(temperature: currentTemperature)
            self.currentTemperatureLbl.text = String(Int(currentTemperature.rounded())) + "˚"
        }
        
        if var feelsLikeTemperature = currentWeather.apparentTemperature{
            feelsLikeTemperature = isDataInImperial ? feelsLikeTemperature : Utilities.convertToFahrenheit(temperature: feelsLikeTemperature)
            self.feelsLikeLbl.text = String(Int(feelsLikeTemperature.rounded())) + "˚F"
        }
        
        if var visibility = currentWeather.visibility{
            visibility = isDataInImperial ? visibility : Utilities.convertKmsToMiles(kms: visibility)
            self.visibilityLbl.text = String(Int(visibility)) + " mi"
        }
        
        self.celsiusBtn.isUserInteractionEnabled = true
        self.celsiusBtn.tintColor = UIColor.darkGray
        self.celsiusBtn.alpha = 0.5
        
        self.fahrenheitBtn.isUserInteractionEnabled = false
        self.fahrenheitBtn.tintColor = UIColor.black
        self.fahrenheitBtn.alpha = 1.0
    }
    
    /**
     *  Gets called to update UI elements representing weather data in Metrics units
     */
    func updateUIForMetricUnits(){
        
        let currentWeather = ResourceManager.sharedManager.currentWeather
        
        let isDataInMetric = !isCountryUsingImperialSystem() // if true data from web service is already in metric
        
        if var currentTemperature = currentWeather.temperature{
            currentTemperature = isDataInMetric ? currentTemperature : Utilities.convertToCelsius(temperature: currentTemperature)
            self.currentTemperatureLbl.text = String(Int(currentTemperature.rounded())) + "˚"
        }
        
        if var feelsLikeTemperature = currentWeather.apparentTemperature{
            feelsLikeTemperature = isDataInMetric ? feelsLikeTemperature : Utilities.convertToCelsius(temperature: feelsLikeTemperature)
            self.feelsLikeLbl.text = String(Int(feelsLikeTemperature.rounded())) + "˚C"
        }
        
        if var visibility = currentWeather.visibility{
            visibility = isDataInMetric ? visibility : Utilities.convertMilesToKms(miles: visibility)
            self.visibilityLbl.text = String(Int(visibility)) + " kms"
        }
        
        self.celsiusBtn.isUserInteractionEnabled = false
        self.celsiusBtn.tintColor = UIColor.black
        self.celsiusBtn.alpha = 1.0
        
        self.fahrenheitBtn.isUserInteractionEnabled = true
        self.fahrenheitBtn.tintColor = UIColor.darkGray
        self.fahrenheitBtn.alpha = 0.5
    }
    
    /**
     *  Gets called after the API call completes fetching weather data
     */
    func updateWeatherUI() {
        
        if (isCountryUsingImperialSystem()){
            updateUIForImperialUnits()
        }
        else{
            updateUIForMetricUnits()
        }
        
        let currentWeather = ResourceManager.sharedManager.currentWeather
        
        self.selectedCityLbl.text = UserDefaults.standard.string(forKey: "city") ?? "Unknown City"
        
        if let currentSummary = currentWeather.currentSummary{
            self.currentWeatherSummaryLbl.text = currentSummary
        }
        
        if let humidity = currentWeather.humidity{
            self.humidityLbl.text = String(Int(humidity*100)) + "%"
        }
        
        if let icon = currentWeather.icon{
            self.currentWeatherIcon.image = UIImage(named: icon) ?? UIImage(named: "default_weather")
        }
        else{
            self.currentWeatherIcon.image = UIImage(named: "default_weather")
        }
        
        if let lastUpdated = currentWeather.time{
            self.lastUpdatedLbl.text = lastUpdated
        }
        
        if let minutelySummary = currentWeather.minutelySummary{
            self.nextHourSummaryTextView.text = minutelySummary
        }
        
        if let uvIndex = currentWeather.uvIndex{
            self.uvIndexLbl.text = String(Int(uvIndex))
        }
        
        self.activityIndicator.stopAnimating()
    }
    
    
    // MARK:- IBAction
    
    /**
     *  Called when Celsius button is tapped.
     *
     *  @param sender
     */
    @IBAction func celsiusTapped(_ sender: Any) {
        updateUIForMetricUnits()
    }
    
    /**
     *  Called when Fahrenheit button is tapped.
     *
     *  @param sender
     */
    @IBAction func fahrenheitTapped(_ sender: Any) {
        updateUIForImperialUnits()
    }
    
    
    
}


