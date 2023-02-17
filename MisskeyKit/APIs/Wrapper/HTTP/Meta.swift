//
//  Meta.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class Meta: Api {
        private let handler: ApiHandler
        required init(from handler: ApiHandler) {
            self.handler = handler
        }
        
        public func get(result callback: @escaping MetaCallBack) {
            var params = [:] as [String: Any]
            
            params = params.removeRedundant()
            handler.handleAPI(needApiKey: true, api: "meta", params: params, type: MetaModel.self) { meta, error in
                
                if let error = error { callback(nil, error); return }
                guard let meta = meta else { callback(nil, error); return }
                
                callback(meta, nil)
            }
        }
        
        public func getEmojis(result callback: @escaping EmojisCallBack) {
            var params = [:] as [String: Any]
            
            params = params.removeRedundant()
            handler.handleAPI(needApiKey: true, api: "emojis", params: params, type: [String:[EmojiModel]].self) { items, error in
                
                if let error = error { callback(nil, error); return }
                guard let items = items else { callback(nil, error); return }
                
                callback(items["emojis"], nil)
            }
        }
    }
}
