//
//  ApiUrl.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

internal class UrlHelper {
    internal var instance: String = "misskey.io" {
        didSet {
            self.instance = self.shapeUrl(self.instance)
        }
    }
    
    internal func fullUrl(_ api: String) -> String {
        if api.prefix(1) == "/" {
            return "https://\(instance)/api" + api
        }
        
        return "https://\(instance)/api/" + api
    }
    
    private func shapeUrl(_ url: String) -> String {
        return url.replacingOccurrences(of: "http(s|)://([^/]+).+",
                                        with: "$2",
                                        options: .regularExpression)
    }
}
