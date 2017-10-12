//
//  SettingsViewController.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/11/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        setupOutlets()
    }

    func setupOutlets() {
        locationTextField.text = locationString
        tempScaleTextLabel.text = "Temperature Scale: \(tempScale.rawValue)"
        if tempScale == .fahrenheit {
            tempScaleSegmentControl.selectedSegmentIndex = 0
        } else {
            tempScaleSegmentControl.selectedSegmentIndex = 1
        }
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
