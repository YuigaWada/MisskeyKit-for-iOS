//
//  Users.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class Users {
        
        //MARK:- Get User Detail
        public func showUser(userId: String = "", host: String = "", completion callback: @escaping OneUserCallBack) {
            
            var params = ["userId": userId,
                          "host": host] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/show", params: params, type: UserModel.self) { user, error in
                if let error = error  { callback(nil, error); return }
                guard let user = user else { callback(nil, error); return }
                
                callback(user,nil)
            }
        }
        
        public func showUser(username: String = "", host: String = "", completion callback: @escaping OneUserCallBack) {
            
            var params = ["username": username,
                          "host": host] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/show", params: params, type: UserModel.self) { user, error in
                if let error = error  { callback(nil, error); return }
                guard let user = user else { callback(nil, error); return }
                
                callback(user,nil)
            }
        }
        
        
        public func showUser(userIds: [String] = [], host: String = "", completion callback: @escaping UsersCallBack) {
            
            var params = ["userIds": userIds,
                          "host": host] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/show", params: params, type: [UserModel].self) { users, error in
                if let error = error  { callback(nil, error); return }
                guard let users = users else { callback(nil, error); return }
                
                callback(users,nil)
            }
        }
        
        
        
        
        
        //MARK:- Get Followee / Follower
        public func getFollowers(userId: String = "", username: String = "", host: String = "", limit: Int=10, sinceId:String="", untilId: String="", completion callback: @escaping UsersCallBack) {
            
            var params = ["userId": userId,
                          "username": username,
                          "host": host,
                          "limit": limit,
                          "sinceId": sinceId,
                          "untilId": untilId] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/followers", params: params, type: [UserModel].self) { posts, error in
                if let error = error  { callback(nil, error); return }
                guard let posts = posts else { callback(nil, error); return }
                
                callback(posts,nil)
            }
        }
        
        public func getFollowing(userId: String = "", username: String = "", host: String = "", limit: Int=10, sinceId:String="", untilId: String="", completion callback: @escaping UsersCallBack) {
            
            var params = ["userId": userId,
                          "username": username,
                          "host": host,
                          "limit": limit,
                          "sinceId": sinceId,
                          "untilId": untilId] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/following", params: params, type: [UserModel].self) { posts, error in
                if let error = error  { callback(nil, error); return }
                guard let posts = posts else { callback(nil, error); return }
                
                callback(posts,nil)
            }
        }
        
        public func getFrequentlyRepliedUsers(userId: String = "", limit: Int=10, completion callback: @escaping UsersCallBack) {
            
            var params = ["userId": userId,
                          "limit": limit] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(api: "users/get-frequently-replied-users", params: params, type: [UserModel].self) { posts, error in
                if let error = error  { callback(nil, error); return }
                guard let posts = posts else { callback(nil, error); return }
                
                callback(posts,nil)
            }
        }
        
        
        //MARK:- User Recommendation
        public func getUserRecommendation(limit: Int = 10, offset: Int = 0, result callback: @escaping UsersCallBack) {
            
            var params = ["limit":limit,
                          "offset":offset] as [String : Any]
            
            params = params.removeRedundant()
            MisskeyKit.handleAPI(needApiKey: true, api: "users/recommendation", params: params, type: [UserModel].self) { users, error in
                
                if let error = error  { callback(nil, error); return }
                guard let users = users else { callback(nil, error); return }
                
                callback(users,nil)
            }
        }
        
        
    }
}
