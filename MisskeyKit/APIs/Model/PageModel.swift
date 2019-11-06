//
//  PageModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/07.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation


public struct PageModel: Codable {
    let id, createdAt, updatedAt, userId: String?
    let user: _User? // isnt normal UserModel class.
    let content: [Content]?
    let variables: [String?]?
    let title, name: String?
    let summary: String?
    let hideTitleWhenPinned, alignCenter: Bool?
    let font: String?
    let eyeCatchingImageId, eyeCatchingImage: String?
    let attachedFiles: [File?]?
    let likedCount: Int?
    let isLiked: Bool?
    
    public struct Content: Codable {
        let id: String?
        let contentVar: String?
        let text, type, event, action: String?
        let content: String?
        let message: String?
        let primary: Bool?
    }
    
    public struct _User: Codable {
        let id, name, username: String?
        let host: String?
        let avatarURL: String?
        let avatarColor: String?
        let isBot, isCat: Bool?
        let emojis: [Emoji?]?
    }

}

