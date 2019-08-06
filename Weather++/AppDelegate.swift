//
//  AppDelegate.swift
//  Weather++
//
//  Created by Rohan Patel on 7/23/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var rootVC = UIViewController()
        
        // Decide which view controller to display at launch based on where user left
        if isPermissionsSet() && isLocationSet() {
            rootVC = storyboard.instantiateViewController(withIdentifier: "WeatherViewController")
        }
        else{
            if isPermissionsSet(){
                rootVC = storyboard.instantiateViewController(withIdentifier: "LocationViewController")
            }
            else{
                rootVC = storyboard.instantiateViewController(withIdentifier: "PermissionsViewController")
            }
        }
        
        window!.rootViewController = UINavigationController(rootViewController: rootVC)
        window!.makeKeyAndVisible()
        
        return true
    }
    
    /**
     *  Checks if user was on PermissionsViewController or not.
     *
     *  @param  none
     *
     *  @return A boolean indicating if user left the app on PermissionsViewController or not.
     */
    func isPermissionsSet() -> Bool {
        if (UserDefaults.standard.bool(forKey: "IsPermissionsSet")) {
            return true
        }
        else {
            return false
        }
    }
    
    /**
     *  Checks if user was on LocationViewController or not
     *
     *  @param  none
     *
     *  @return A boolean indicating if user left the app on LocationViewController or not.
     */
    func isLocationSet() -> Bool {
        if (UserDefaults.standard.bool(forKey: "IsLocationSet")){
            return true
        }
        else{
            return false
        }
    }
    
    // called by iOS to perform background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        WeatherDataManager.getLatestWeatherData {
            
            self.isNotificationAllowed { (result) in
                if result{
                    self.scheduleNotifications()
                }
            }
            completionHandler(.newData)
        }
    }
    
    /**
     *  Checks whether the user has allowed notification or not.
     *
     *  @param completion Callback block that executes after obtaining notifications settings
     *
     */
    func isNotificationAllowed(completion: @escaping (Bool) -> Void){
        
        var result = false
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized{
                result = false
            }
            else{
                if settings.alertSetting == .enabled{
                    result = true
                }
                else{
                    result = false
                }
            }
            completion(result)
        }
    }
    
    /**
     *  Schedules a notification with weather updates that includes
     *  current temperature, current weather condition and weather conditions for
     *  an upcoming hour.
     */
    func scheduleNotifications(){
        
        let content = UNMutableNotificationContent()
        let currentWeather = ResourceManager.sharedManager.currentWeather
        
        guard let temperature = currentWeather.temperature,
            let city = UserDefaults.standard.string(forKey: "city") else {
                return
        }
        
        content.title = "\(city): "
        
        if let currentSummary = currentWeather.currentSummary{
            content.title = "\(city): " + String(Int(temperature)) + "˚F" + " , \(currentSummary)"
        }
        else{
            content.title = "\(city): " + String(Int(temperature)) + "˚F"
        }
        
        let bodyText =  currentWeather.minutelySummary ?? ""
        
        if (bodyText != ""){
            content.body =  "Next hour: " + bodyText
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: "WPPCurrentWeatherNotification", content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
}

