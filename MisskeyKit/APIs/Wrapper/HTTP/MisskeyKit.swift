//
//  MisskeyKit.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/04.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

open class MisskeyKit {
    
    //MARK:- Singleton
    static public let auth: Auth = MisskeyKit.Auth()
    static public var notes: MisskeyKit.Notes = MisskeyKit.Notes()
    static public var users: MisskeyKit.Users = MisskeyKit.Users()
    static public var groups: MisskeyKit.Groups = MisskeyKit.Groups()
    static public var lists: MisskeyKit.Lists = MisskeyKit.Lists()
    static public var search: MisskeyKit.Search = MisskeyKit.Search()
    static public var notifications: MisskeyKit.Notifications = MisskeyKit.Notifications()
    static public var meta: MisskeyKit.Meta = MisskeyKit.Meta()
    
    static public var streaming: MisskeyKit.Streaming = MisskeyKit.Streaming()
    
    
    public static func changeInstance(instance: String = "misskey.io") {
        Api.instance = instance
    }
    
     //MARK:- Internal Methods
       internal static func handleAPI<T>(needApiKey: Bool = false, api: String, params: [String: Any], type: T.Type, missingCount: Int? = nil, callback: @escaping (T?, Error?)->Void) where T : Decodable  {
           if let missingCount = missingCount
           {
               guard missingCount < 4 else {
                   return callback(nil,NSError(domain: "Internal Error: Failed to communicate with Misskey Server.", code: -1, userInfo: nil))
               }
           }
           
           var params = params
           if needApiKey {
               params["i"] = auth.getAPIKey()
           }
           
           guard let rawJson = params.toRawJson()  else {
               let error = NSError(domain: "Internal Error: Failed to generate json.", code: -1, userInfo: nil)
               callback(nil, error)
               return
           }
           
           
           Requestor.post(url: Api.fullUrl(api), rawJson: rawJson) { (response: HTTPURLResponse?, resultRawJson: String?, error: Error?) in
               guard let resultRawJson = resultRawJson else {
                   if let missingCount = missingCount {
                       self.handleAPI(needApiKey: needApiKey,
                                      api: api,
                                      params: params,
                                      type: type,
                                      missingCount: missingCount + 1,
                                      callback: callback)
                   }
                   
                   // If being initial error...
                   self.handleAPI(needApiKey: needApiKey,
                                  api: api,
                                  params: params,
                                  type: type,
                                  missingCount: 1,
                                  callback: callback)
                   
                   return
               }
               
               let resultJson = arrayReactions(rawJson: resultRawJson) // Changes a form of reactions to array.
               
            if let response = response, response.statusCode == 200, resultJson.count == 0  {
                callback(nil, nil)
            }
            
            guard let json = resultJson.decodeJSON(type) else {
                if resultJson.count == 0 {
                    guard String(reflecting: T.self) == "Swift.Bool" else {
                        callback(nil, NSError(domain: "Internal Error: Failed to recieve json data correctly.", code: -1, userInfo: nil))
                        return
                    }
                    
                    callback(nil, nil)
                    return
                }
                
                let error = MisskeyError.checkNative(rawJson: resultJson, "Internal Error: Failed to decode json.")
                callback(nil, error)
                return
            }
            
            callback(json, nil)
        }
    }
    
    
    // ** 参考 **
    //reactionsのkeyは無数に存在するため、codableでのパースは難しい。
    //そこで、生のjsonを直接弄り、reactionsを配列型に変更する。
    //Ex: "reactions":{"like":2,"😪":2} → "reactions":[{name:"like",count:2},{name:"😪",count:2}]
    
    internal static func arrayReactions(rawJson: String)-> String {
        
        //reactionsを全て取り出す
        let reactionsList = rawJson.regexMatches(pattern: "(\"reactions\":\\{[^\\}]*\\})")
        guard reactionsList.count > 0 else { return rawJson }
        
        
        var replaceList: [String] = []
        reactionsList.forEach{ // {"like":2,"😪":2} → [{name:"like",count:2},{name:"😪",count:2}]
            let reactions = $0[0]
            let shapedReactions = reactions.replacingOccurrences(of: "\\{([^\\}]*)\\}", with: "[$1]", options: .regularExpression)
                .replacingOccurrences(of: "\"([^\"]+)\":([0-9]+)", with: "{\"name\":\"$1\",\"count\":\"$2\"}", options: .regularExpression)
            
            replaceList.append(shapedReactions)
        }
       
        var replacedRawJson = rawJson
        for i in 0...reactionsList.count-1 {
            replacedRawJson = replacedRawJson.replacingOccurrences(of: reactionsList[i][0], with: replaceList[i])
        }
        
        return replacedRawJson
    }
    
}

