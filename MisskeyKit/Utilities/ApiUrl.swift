//
//  ApiUrl.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation


internal class Api {
    
    static func fullUrl(_ api: String)-> String {
        
        if api.prefix(1) == "/" {
            return "https://misskey.io/api" +  api
        }
        
        return "https://misskey.io/api/" +  api
    }
    
}
