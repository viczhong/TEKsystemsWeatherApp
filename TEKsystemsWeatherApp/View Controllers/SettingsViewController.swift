//
//  SettingsViewController.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit
import CoreLocation

protocol  SettingsDelegate {
    func changeSettings(_ controller: SettingsViewController, _ location: String, _ scale: TempScale)
}

enum TempScale: String {
    case fahrenheit  = "Fahrenheit"
    case celsius = "Celsius"
}

class SettingsViewController: UIViewController {
    // MARK: Properties and Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tempScaleTextLabel: UILabel!
    @IBOutlet weak var tempScaleSegmentControl: UISegmentedControl!

    var delegate: SettingsDelegate!
    var locationString: String!
    var tempScale: TempScale!
    let locationManager = CLLocationManager()
    var locations = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        setupOutlets()
        startCheckingLocation(locationManager)
    }

    // MARK: - Functions
    func setupOutlets() {
        locationTextField.text = locationString
        tempScaleTextLabel.text = "Temperature Scale: \(tempScale.rawValue)"
        if tempScale == .fahrenheit {
            tempScaleSegmentControl.selectedSegmentIndex = 0
        } else {
            tempScaleSegmentControl.selectedSegmentIndex = 1
        }
    }

    @IBAction func detectLocationButtonTapped(_ sender: Any) {
        findLocation(locationManager, didUpdateLocations: locations)
    }


    @IBAction func tempScaleSegmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tempScale = .fahrenheit
        } else {
            tempScale = .celsius
        }

        tempScaleTextLabel.text = "Temperature Scale: \(tempScale.rawValue)"
    }

    @IBAction func applyButtonTapped(_ sender: Any) {
        delegate.changeSettings(self, locationString, tempScale)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    // MARK: - UITextField Stuff
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let search = textField.text {
            locationString = search
        }

        textField.resignFirstResponder()
        return true
    }
}

extension SettingsViewController: CLLocationManagerDelegate {
    func startCheckingLocation(_ locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func findLocation(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {

        if let location = manager.location {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        if let pm = placemarks[0].postalCode {
                            self.locationTextField.text = pm
                            self.locationString = pm
                        }
                    }

                    manager.stopUpdatingLocation()
                }

                if let error = error {
                    print("Error during location session: \(error.localizedDescription)")
                    return
                }
            })
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please Enable Location Services for TEKsystems Weather in Settings", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

