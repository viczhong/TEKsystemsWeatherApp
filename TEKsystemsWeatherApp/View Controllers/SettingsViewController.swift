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

enum TempScale {
    case fahrenheit, celsius
}

class SettingsViewController: UIViewController {
    // MARK: Properties and Outlets
    var delegate: SettingsDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

}
