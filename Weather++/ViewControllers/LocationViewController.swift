//
//  LocationViewController.swift
//  Weather++
//
//  Created by Rohan Patel on 7/28/19.
//  Copyright © 2019 Rohan Patel. All rights reserved.
//

import UIKit
import CoreLocation

/**
 *  Initiates the navigation to LocationViewController
 */

/* A view controller class that allows users to prvoide their location for
 * weather updates
 */
class LocationViewController: UIViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var getLocationBtn: UIButton!
    
    @IBOutlet weak var locationSearchResultLbl: UILabel!
    
    @IBOutlet weak var zipcodeTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.zipcodeTxtField.delegate = self
    }
    
    // MARK:- IBAction
    
    /**
     *  Called when Continue button is tapped to navigate to `WeatherViewController`
     *
     *  @param sender
     */
    @IBAction func continueTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "IsLocationSet")
    }
    
    
    /**
     *  Called when `Get Location` button is tapped. It get the details of current location
     *  like coordinates (longitude, lattitude), locality, country etc.
     *
     *  @param sender
     */
    @IBAction func getLocationTapped(_ sender: Any) {
        
        guard let zipcode = zipcodeTxtField.text else {
            return
        }
        
        CLGeocoder().geocodeAddressString(zipcode) { (placemarks, error) in
            if let _ = error{
                self.locationSearchResultLbl.text = "Can't find the location. Try again!"
                self.locationSearchResultLbl.textColor = UIColor.red
            }
            else{
                if let placemarks = placemarks{
                    
                    guard let location = placemarks.first?.location, let city = placemarks.first?.locality else {
                        return
                    }
                    UserDefaults.standard.set(location.coordinate.latitude, forKey: "latitude")
                    UserDefaults.standard.set(location.coordinate.longitude, forKey: "longitude")
                    UserDefaults.standard.set(city, forKey: "city")
                    
                    DispatchQueue.main.async {
                        self.continueBtn.isEnabled = true
                        self.continueBtn.alpha = 1.0
                        self.locationSearchResultLbl.text = city
                        self.locationSearchResultLbl.textColor = UIColor.black
                        self.view.endEditing(true)
                    }
                    
                    if let country = placemarks.first?.country{
                        UserDefaults.standard.set(country, forKey: "country")
                    }
                }
            }
        }
    }
    
    // MARK:- Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - IBActions
    
    /**
     *  Called whenever the `zipcodeTxtField` content is changed.
     *
     *  @param sender
     */
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if (zipcodeTxtField.text?.count ?? 0 > 4){
            self.getLocationBtn.isEnabled = true
            self.getLocationBtn.alpha = 1.0
        }
        else{
            self.getLocationBtn.isEnabled = false
            self.getLocationBtn.alpha = 0.5
            
            self.continueBtn.isEnabled = false
            self.continueBtn.alpha = 0.5
        }
    }
}

extension LocationViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        // limit text entry to 10 characters
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10
    }
}
