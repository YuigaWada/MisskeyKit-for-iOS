//
//  MisskeyError.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//



public class MisskeyError: Codable {
    
    let error: Details?
    
    public class Details: Codable  {
    let message, code, id, kind: String?
    }
    
    static func checkNative(rawJson: String, _ nonNativeError: String)-> Error {
        
        if let error = rawJson.decodeJSON(MisskeyError.self) {
            guard let details = error.error, let errorMessage = details.message else {
                 return NSError(domain: "Error sent by server has been recieved but MisskeyKit cannot decode this json.", code: -1, userInfo: nil)
            }
            
            return NSError(domain: errorMessage, code: -1, userInfo: nil)
        }
        
        return NSError(domain: nonNativeError, code: -1, userInfo: nil)
    }
}
