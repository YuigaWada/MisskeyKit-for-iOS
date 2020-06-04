//
//  Auth.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class Auth: Api {
        private let handler: ApiHandler
        required init(from handler: ApiHandler) {
            self.handler = handler
        }
        
        public var appSecret: String?
        
        public var me: Me? // infomation of logedin account, which have accessToken
        public var token: Token? // token of SESSION
        public var viewController: AuthViewController {
            let authVC = AuthViewController()
            authVC.setup(from: self)
            return authVC
        }
        
        private var apiKey: String?
        
        // MARK: - SET
        
        public func setAPIKey(_ apiKey: String) {
            self.apiKey = apiKey
        }
        
        // MARK: - GET
        
        public func startSession(appSecret: String, completion callback: @escaping AuthCallBack) {
            self.appSecret = appSecret
            
            let params = ["appSecret": appSecret]
            
            handler.handleAPI(needApiKey: true, api: "auth/session/generate", params: params, type: Token.self) { token, error in
                if let error = error { callback(nil, error); return }
                guard let token = token else { callback(nil, error); return }
                
                self.token = token
                callback(self, error)
            }
        }
        
        public func getAccessToken(completion callback: @escaping AuthCallBack) {
            guard let token = self.token, let appSecret = appSecret else { return }
            
            let params = ["appSecret": appSecret, "token": token.token]
            
            handler.handleAPI(needApiKey: true, api: "/auth/session/userkey", params: params, type: Me.self) { me, error in
                if let error = error { callback(nil, error); return }
                guard let me = me else { callback(nil, error); return }
                
                self.me = me
                callback(self, error)
            }
        }
        
        public func getAPIKey() -> String? {
            if let apiKey = apiKey, !apiKey.isEmpty {
                return apiKey
            } else {
                guard let me = me, let appSecret = appSecret else { return nil }
                let seed = me.accessToken + appSecret
                
                return seed.sha256()
            }
        }
    }
}
