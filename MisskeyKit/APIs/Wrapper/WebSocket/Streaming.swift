//
//  Streaming.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation
import Starscream


public typealias StreamingCallBack = (_ response: Any?, _ channel: SentStreamModel.Channel?, Error?)->Void
extension MisskeyKit {
    public class Streaming {
        
        private var socket: WebSocket?
        private var ids: [String:SentStreamModel.Channel] = [:]
        
        public var isConnected: Bool = false
        
        deinit {
            guard let socket = socket else {return}
            socket.disconnect(forceTimeout: 0)
            self.socket = nil
        }
        
        //MARK:- Connection
        public func connect(apiKey: String, channels: [SentStreamModel.Channel], response callback: @escaping StreamingCallBack)-> Bool {
            let wsUrlString = "wss://misskey.io/streaming?i=" + apiKey
            guard let wsUrl = URL(string: wsUrlString) else { return false }
            
            self.socket = WebSocket(url: wsUrl)
            setupConnection(channels: channels, callback: callback)
            
            self.socket!.connect()
            return true
        }
        
        
        
        // Private Methods
        private func setupConnection(channels: [SentStreamModel.Channel], callback: @escaping StreamingCallBack) {
            guard let socket = self.socket else { return }
            
            //socket.disableSSLCertValidation = true
            socket.onConnect = {
                self.isConnected = true
                
                socket.write(pong: Data())
                self.shakeHandsForChannnels(channels, callback: callback)
            }
            
            socket.onDisconnect = { (error: Error?) in
                self.isConnected = false
                callback(nil, nil, error)
            }
            
            socket.onText = { (text: String) in
                let (response, channel) = self.handleEvent(rawJson: text)
                callback(response, channel, nil)
            }
            
            socket.onData = { (data: Data) in
                guard let text = String(data: data, encoding: .utf8) else { return }
                let (response, channel) = self.handleEvent(rawJson: text)
                callback(response, channel, nil)
            }
            
        }
        
        private func shakeHandsForChannnels(_ channels: [SentStreamModel.Channel], callback: StreamingCallBack) {
            
            channels.forEach{ channel in
                
                let uuid = NSUUID().uuidString.sha256()!
                let body = SentStreamModel.ChannelBody(channel: channel, id: uuid, params: [:])
                let sentTarget = SentStreamModel(type: "connect", body: body)
                
                ids[uuid] = channel //save uuid pairs.
                
                var jsonData: Data?
                do {
                    jsonData = try JSONEncoder().encode(sentTarget)
                } catch {
                    callback(nil, nil, error)
                    return
                }
                
                let rawJson = String(data: jsonData!, encoding: .utf8)!
                
                self.socket!.write(string: rawJson)
            }
        }
        
        
        
        //MARK:- Handling Events
        
        // json = {type,body / id,type,body / UserModel, NoteModel}
        private func handleEvent(rawJson: String)-> (response: Any?, channel: SentStreamModel.Channel?) {
            guard let (body, otherParams) = self.disassembleJson(rawJson), let type = otherParams["type"] as? String else {return (nil,nil)}
            
            if type != "channel" {
                //~~
                return (nil,nil)
            }
            
            guard let (bodyInBody, otherParamsInBody) = self.disassembleJson(body),
                let id = otherParamsInBody["id"] as? String,
                let typeInBody = otherParamsInBody["type"] as? String else { return (nil,nil) }
            
            let notifNameList = ["notification", "unreadNotification", "readAllNotifications"]
            if notifNameList.contains(typeInBody) {
                //~~
                
                return (nil,nil)
            }
            
            // If not related to notifiaction.
            let BinBjson = bodyInBody.toRawJson()!
            let response = MisskeyKit.arrayReactions(rawJson: BinBjson).decodeJSON(NoteModel.self)
            
            return (response: response, channel: ids[id])
        }
        
        
        
        
        private func disassembleJson(_ rawJson: String)-> (body: [String:Any], others: [String:Any])? {
            do {
                let json = try JSONSerialization.jsonObject(with: rawJson.data(using: .utf8)!) as! [String:Any]
                return self.disassembleJson(json)
            }
            catch { return nil }
        }
        
        private func disassembleJson(_ json: [String:Any])-> (body: [String:Any], others: [String:Any])? {
            guard let bodyJson = json["body"] as? [String:Any] else { return nil }
        
            return (body: bodyJson, others: json)
        }
        
        
    }
}

