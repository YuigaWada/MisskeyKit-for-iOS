//
//  Channel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public struct SentStreamModel: Codable {
    let type: String?
    let body: ChannelBody?
    
    public struct ChannelBody: Codable {
        let channel: Channel?
        let id: String?
        let params: [String:String]?
        
        init(channel: Channel, id: String, params: [String:String]){
            self.channel = channel; self.id = id; self.params = params
        }
    }
    
    public enum Channel: String, Codable {
        case main = "main"
        case homeTimeline = "homeTimeline"
        case localTimeline = "localTimeline"
        case hybridTimeline = "hybridTimeline"
        case globalTimeline = "globalTimeline"
        
        case CapturedNoteUpdated = "CapturedNoteUpdated"
    }
    
    init(type: String, body: ChannelBody){
        self.type = type; self.body = body
    }
}
