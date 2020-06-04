//
//  ServiceWorker.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2020/05/12.
//  Copyright © 2020 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class ServiceWorker: Api {
        private let handler: ApiHandler
        required init(from handler: ApiHandler) {
            self.handler = handler
        }
        
        public func register(endpoint: String, auth: String, publicKey: String, result callback: @escaping SwCallBack) {
            var params = ["endpoint": endpoint,
                          "auth": auth,
                          "publickey": publicKey] as [String: Any?]
            
            params = params.removeRedundant() as [String: Any]
            handler.handleAPI(needApiKey: true, api: "sw/register", params: params as [String: Any], type: ServiceWorkerModel.self) { state, error in
                
                if let error = error { callback(nil, error); return }
                guard let state = state else { callback(nil, error); return }
                
                callback(state, nil)
            }
        }
    }
}
