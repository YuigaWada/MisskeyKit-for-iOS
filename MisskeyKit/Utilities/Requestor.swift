//
//  Requestor.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation


internal typealias ResponseCallBack = (HTTPURLResponse?, String?, MisskeyKitError?) -> Void
internal class Requestor {
    
    static func get(url: String, completion: @escaping ResponseCallBack) {
        self.get(url: URL(string: url)!, completion: completion)
    }
    
    static func get(url: URL, completion: @escaping ResponseCallBack) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil, nil, .FailedToCommunicateWithServer)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil, nil, nil)
                return
            }
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                completion(response, dataString, nil)
            }
        }
        task.resume()
    }
    
    
    
    
    
    static func post(url: String, rawJson: String, completion: @escaping ResponseCallBack) {
        self.post(url: URL(string: url)!,
                  rawJson: rawJson,
                  completion: completion)
    }
    
    static func post(url: URL, rawJson: String, completion: @escaping ResponseCallBack) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = rawJson.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(nil, nil, .FailedToCommunicateWithServer)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil, nil, nil)
                return
            }
            
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                completion(response, dataString, nil)
            }
            
        }
        task.resume()
    }
    
}
