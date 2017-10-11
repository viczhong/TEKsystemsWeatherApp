//
//  APIRequestManager.swift
//  TEKsystemsWeatherApp
//
//  Created by Victor Zhong on 10/10/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {

    static let manager = APIRequestManager()
    public init() {}

    // defaultSession conforms to DHURLSession protocol for FakeTests
    var defaultSession: DHURLSession = URLSession(configuration: .default)

    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }

        let customConfig = URLSessionConfiguration.default
        customConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        customConfig.urlCache = nil

        defaultSession.dataTask(with: myURL) { (data, _, error) in
            if let error = error {
                print("Error during dataTask session: \(error.localizedDescription)")
            }
            callback(data)
            }.resume()
    }
}
