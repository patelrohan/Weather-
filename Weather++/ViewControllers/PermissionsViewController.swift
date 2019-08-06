//
//  PermissionsViewController.swift
//  Weather++
//
//  Created by Rohan Patel on 7/24/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

/* A view controller class that allows users to prvoide their notifications preferences*/

class PermissionsViewController: UIViewController {
    
    @IBOutlet weak var allowNotificationsBtn: UIButton!
    @IBOutlet weak var notNowBtn: UIButton!
    
    @IBOutlet weak var notificationWarningLbl: UILabel!
    
    @IBOutlet weak var zipcodeTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - IBActions
    
    /**
     *  Called when Not Now button is tapped to deny the notification permission
     *
     *  @param sender
     */
    @IBAction func notNowTapped(_ sender: Any) {
        navigateToLocationViewController()
    }
    
    /**
     *  Called when Not Now button is tapped to allow the notification permission
     *
     *  @param sender
     */
    @IBAction func allowNotificationsTapped(_ sender: Any) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            //navigate to Location View
            DispatchQueue.main.async {
                self.navigateToLocationViewController()
            }
            
            UserDefaults.standard.set(true, forKey: "IsPermissionsSet")
        }
        
    }
    
    // MARK: - Navigation
    
    /**
     *  Initiates the navigation to `LocationViewController`
     */
    func navigateToLocationViewController(){
        let locationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
        self.navigationController?.pushViewController(locationVC!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(true, forKey: "IsPermissionsSet")
    }
}

