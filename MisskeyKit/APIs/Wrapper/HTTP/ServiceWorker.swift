//
//  ServiceWorker.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2020/05/12.
//  Copyright © 2020 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class ServiceWorker {
        
        public func register(endpoint: String, auth: String, publicKey:String, callbackUrl: String? = nil, result callback: @escaping SwCallBack) {
            
            var params = ["endpoint":endpoint,
                          "auth":auth,
                          "publicKey":publicKey] as [String : Any?]
            
            params = params.removeRedundant() as [String : Any]
            MisskeyKit.handleAPI(needApiKey: false, api: "sw/register", params: params as [String : Any], type: ServiceWorkerModel.self) { state, error in
                
                if let error = error  { callback(nil, error); return }
                guard let state = state else { callback(nil, error); return }
                
                callback(state, nil)
            }
        }
    }
}
