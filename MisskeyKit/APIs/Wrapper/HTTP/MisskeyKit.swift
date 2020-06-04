//
//  MisskeyKit.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/04.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

protocol Api {
    init(from handler: ApiHandler)
}

protocol ApiHandler {
    // MARK: Helper
    
    var urlHelper: UrlHelper { get }
    func arrayReactions(rawJson: String) -> String
    
    // MARK: Handling
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], data: Data?, fileType: String?, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], fileType: String?, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], data: Data?, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable
}

open class MisskeyKit: ApiHandler {
    // MARK: - Singleton
    
    public static let shared: MisskeyKit = .init()
    
    // MARK: Main REST
    
    public lazy var auth: Auth = .init(from: self)
    public lazy var notes: MisskeyKit.Notes = .init(from: self)
    public lazy var users: MisskeyKit.Users = .init(from: self)
    public lazy var groups: MisskeyKit.Groups = .init(from: self)
    public lazy var lists: MisskeyKit.Lists = .init(from: self)
    public lazy var search: MisskeyKit.Search = .init(from: self)
    public lazy var notifications: MisskeyKit.Notifications = .init(from: self)
    public lazy var drive: MisskeyKit.Drive = .init(from: self)
    public lazy var messaging: MisskeyKit.Messaging = .init(from: self)
    
    // MARK: Meta
    
    public lazy var app: MisskeyKit.App = .init(from: self)
    public lazy var meta: MisskeyKit.Meta = .init(from: self)
    public lazy var emojis: MisskeyKit.Emojis = .init(from: meta)
    
    // MARK: Main Streaming
    
    public lazy var streaming: MisskeyKit.Streaming = .init(from: self)
    
    internal let urlHelper: UrlHelper = .init()
    
    public init() {}
    
    public func changeInstance(instance: String = "misskey.io") {
        urlHelper.instance = instance
    }
    
    // MARK: - Handling
    
    func handleAPI<T>(needApiKey: Bool = false, api: String, params: [String: Any], data: Data? = nil, fileType: String? = nil, type: T.Type, missingCount: Int? = nil, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        let hasAttachment = data != nil
        
        if hasAttachment, fileType == nil { return } // If fileType being nil ...
        
        if let missingCount = missingCount, missingCount >= 4 { return callback(nil, .FailedToCommunicateWithServer) }
        
        var params = params
        if needApiKey {
            params["i"] = auth.getAPIKey()
        }
        
        let completion = { (response: HTTPURLResponse?, resultRawJson: String?, error: MisskeyKitError?) in
            self.handleResponse(response: response,
                                resultRawJson: resultRawJson,
                                error: error,
                                needApiKey: needApiKey,
                                api: api,
                                params: params,
                                data: data,
                                fileType: fileType,
                                type: T.self,
                                missingCount: missingCount,
                                callback: callback)
        }
        
        if !hasAttachment {
            guard let rawJson = params.toRawJson() else { callback(nil, .FailedToDecodeJson); return }
            Requestor.post(url: urlHelper.fullUrl(api), rawJson: rawJson, completion: completion)
        } else {
            Requestor.post(url: urlHelper.fullUrl(api), paramsDic: params, data: data, fileType: fileType, completion: completion)
        }
    }
    
    func handleAPI<T>(needApiKey: Bool = false, api: String, params: [String: Any], data: Data? = nil, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        handleAPI(needApiKey: needApiKey, api: api, params: params, data: data, fileType: nil, type: T.self, callback: callback)
    }
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], fileType: String?, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        handleAPI(needApiKey: needApiKey, api: api, params: params, data: nil, fileType: fileType, type: T.self, callback: callback)
    }
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        handleAPI(needApiKey: needApiKey, api: api, params: params, data: nil, fileType: nil, type: T.self, callback: callback)
    }
    
    func handleAPI<T>(needApiKey: Bool, api: String, params: [String: Any], data: Data?, fileType: String?, type: T.Type, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        handleAPI(needApiKey: needApiKey, api: api, params: params, data: data, fileType: fileType, type: T.self, missingCount: nil, callback: callback)
    }
    
    // ** 参考 **
    // reactionsのkeyは無数に存在するため、codableでのパースは難しい。
    // そこで、生のjsonを直接弄り、reactionsを配列型に変更する。
    // Ex: "reactions":{"like":2,"😪":2} → "reactions":[{name:"like",count:2},{name:"😪",count:2}]
    
    func arrayReactions(rawJson: String) -> String {
        // reactionsを全て取り出す
        let reactionsList = rawJson.regexMatches(pattern: "(\"reactions\":\\{[^\\}]*\\})")
        guard reactionsList.count > 0 else { return rawJson }
        
        var replaceList: [String] = []
        reactionsList.forEach { // {"like":2,"😪":2} → [{name:"like",count:2},{name:"😪",count:2}]
            let reactions = $0[0]
            let shapedReactions = reactions.replacingOccurrences(of: "\\{([^\\}]*)\\}", with: "[$1]", options: .regularExpression)
                .replacingOccurrences(of: "\"([^\"]+)\":([0-9]+)", with: "{\"name\":\"$1\",\"count\":\"$2\"}", options: .regularExpression)
            
            replaceList.append(shapedReactions)
        }
        
        var replacedRawJson = rawJson
        for i in 0 ... reactionsList.count - 1 {
            replacedRawJson = replacedRawJson.replacingOccurrences(of: reactionsList[i][0], with: replaceList[i])
        }
        
        return replacedRawJson
    }
    
    // MARK: Private Methods
    
    private func handleResponse<T>(response: HTTPURLResponse?, resultRawJson: String?, error: MisskeyKitError?, needApiKey: Bool = false, api: String, params: [String: Any], data: Data? = nil, fileType: String? = nil, type: T.Type, missingCount: Int? = nil, callback: @escaping (T?, MisskeyKitError?) -> Void) where T: Decodable {
        guard let resultRawJson = resultRawJson else {
            if let missingCount = missingCount {
                handleAPI(needApiKey: needApiKey,
                          api: api,
                          params: params,
                          type: type,
                          missingCount: missingCount + 1,
                          callback: callback)
                return
            }
            
            // If being initial error...
            handleAPI(needApiKey: needApiKey,
                      api: api,
                      params: params,
                      type: type,
                      missingCount: 1,
                      callback: callback)
            
            return
        }
        
        let resultJson = arrayReactions(rawJson: resultRawJson) // Changes a form of reactions to array.
        
        if let response = response, response.statusCode == 200, resultJson.count == 0 {
            callback(nil, nil)
            return
        }
        
        guard let json = resultJson.decodeJSON(type) else {
            if resultJson.count == 0 {
                guard String(reflecting: T.self) == "Swift.Bool" else {
                    callback(nil, .ResponseIsNull)
                    return
                }
                
                callback(nil, nil)
                return
            }
            
            // guard上のifでnilチェックできているので強制アンラップでOK
            let error = ApiError.checkNative(rawJson: resultJson, response!.statusCode)
            callback(nil, error)
            return
        }
        
        callback(json, nil)
    }
}
