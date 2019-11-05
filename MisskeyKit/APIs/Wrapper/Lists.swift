//
//  Lists.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class Lists {
        
        public func pullUser(listId: String = "", userId: String = "", result callback: @escaping BooleanCallBack) {
            
            var params = ["listId":listId,
                          "userId":userId] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(needApiKey: true, api: "users/lists/pull", params: params, type: [NoteModel].self) { _, error in
                callback(error == nil, error)
            }
        }
        
        public func pushUser(listId: String = "", userId: String = "", result callback: @escaping BooleanCallBack) {
            
            var params = ["listId":listId,
                          "userId":userId] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(needApiKey: true, api: "users/lists/push", params: params, type: [NoteModel].self) { _, error in
                callback(error == nil, error)
            }
        }
        
    }
}
