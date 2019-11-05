//
//  Streaming.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation
import Starscream


public typealias StreamingCallBack = (String?, Error?)->Void
extension MisskeyKit {
    public class Streaming {
        
        private var socket: WebSocket?
        
        public var isConnected: Bool = false
        
        deinit {
            guard let socket = socket else {return}
            socket.disconnect(forceTimeout: 0)
            self.socket = nil
        }
        
        
        public func connect(apiKey: String, channels: [SentStreamModel.Channel], response callback: @escaping StreamingCallBack)-> Bool {
            let wsUrlString = "wss://misskey.io/streaming?i=" + apiKey
            guard let wsUrl = URL(string: wsUrlString) else { return false }
            
            self.socket = WebSocket(url: wsUrl)
            self.socket!.connect()
            
            setupConnection(channels: channels, callback: callback)
            return true
        }
        
        private func setupConnection(channels: [SentStreamModel.Channel], callback: @escaping StreamingCallBack) {
            guard let socket = self.socket else { return }
            
//            socket.disableSSLCertValidation = true
            socket.onConnect = {
                self.isConnected = true
                
                socket.write(pong: Data())
                self.shakeHandsForChannnels(channels, callback: callback)
            }
            
            socket.onDisconnect = { (error: Error?) in
                self.isConnected = false
                callback(nil, error)
            }
            
            socket.onText = { (text: String) in
                callback(text, nil)
            }
            
            socket.onData = { (data: Data) in
                let text = String(data: data, encoding: .utf8)
                
                callback(text, nil)
            }
            
        }
        
        private func shakeHandsForChannnels(_ channels: [SentStreamModel.Channel], callback: StreamingCallBack) {
            
            channels.forEach{ channel in
                
                let uuid = NSUUID().uuidString.sha256()!
                let body = SentStreamModel.ChannelBody(channel: channel, id: uuid, params: [:])
                
                let sentTarget = SentStreamModel(type: "connect", body: body)
                
                var jsonData: Data?
                do {
                    jsonData = try JSONEncoder().encode(sentTarget)
                } catch {
                    callback(nil,error)
                    return
                }
                
                let rawJson = String(data: jsonData!, encoding: .utf8)!
                
                self.socket!.write(string: rawJson)
            }
        }
        
    }
}

