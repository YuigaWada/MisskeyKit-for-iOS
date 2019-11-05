//
//  MisskeyError.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//



public class MisskeyError: Codable {
    let message, code, id: String?
    
    static func checkNative(rawJson: String, _ nonNativeError: String)-> Error {
        
        if let error = rawJson.decodeJSON(MisskeyError.self) {
            return NSError(domain: error.message!, code: -1, userInfo: nil)
        }
        
        return NSError(domain: nonNativeError, code: -1, userInfo: nil)
    }
}
