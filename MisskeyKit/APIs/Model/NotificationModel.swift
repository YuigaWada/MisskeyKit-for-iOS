//
//  NotificationModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public struct NotificationModel: Codable {
    public let id: String?
    public let createdAt: String?
    public let type: ActionType?
    public let userId: String?
    public let user: UserModel?
    public let reaction: String?
    public let note: NoteModel?
}

public enum ActionType: String, Codable {
    case follow
    case mention
    case reply
    case renote
    case quote
    case reaction
    case pollVote
    case receiveFollowRequest
    case followRequestAccepted
}
