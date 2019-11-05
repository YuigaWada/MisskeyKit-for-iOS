//
//  NotificationModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation


public struct NotificationModel: Codable {
    let id: String?
    let createdAt: String?
    let type: ActionType?
    let userId: String?
    let user: UserModel?
    let reaction: String?
    let note: NoteModel?
}


public enum ActionType: String, Codable {
    case follow = "follow"
    case mention = "mention"
    case reply = "reply"
    case renote = "renote"
    case quote = "quote"
    case reaction = "reaction"
    case pollVote = "pollVote"
    case receiveFollowRequest = "receiveFollowRequest"
}
