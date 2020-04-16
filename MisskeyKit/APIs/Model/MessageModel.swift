//
//  MessageModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/10.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public struct MessageHistoryModel: Codable {
    public let id: String?
    public let createdAt: String?
    public let userId: String?
    public let user: UserModel?
    public let text, fileId: String?
    public let file: File?
    public let recipientId: String?
    public let recipient: UserModel?
    public let groupId: String?
    public let group: GroupModel?
    public let isRead: Bool?
    public let reads: [String]?
}

public struct MessageModel: Codable {
    public let id: String?
    public let createdAt: String?
    public let userId: String?
    public let user: UserModel?
    public let text, fileId: String?
    public let file: File?
    public let recipientId: String?
    public let recipient: UserModel?
    public let groupId: String?
    public let group: GroupModel?
    public let isRead: Bool?
    public let reads: [String]?
}

public struct GroupModel: Codable {
    public let id: String?
    public let createdAt: String?
    public let name, ownerId: String?
    public let userIds: [String]?
}
