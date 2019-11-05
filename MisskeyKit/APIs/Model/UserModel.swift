//
//  User.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/04.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//
import Foundation

// MARK: - Me
public struct Me: Codable {
    var accessToken: String
    var user: UserModel?
}

public struct UserModel: Codable {
    var id: String
    var name: String?
    var username: String?
    var description: String?
    var host: String?
    var avatarUrl: String?
    var avatarColor: String?
    var isAdmin, isBot, isCat: Bool?
    var emojis: [Emoji?]?
    var url: String?
    var createdAt, updatedAt: String?
    var bannerUrl, bannerColor: String?
    var isLocked, isModerator, isSilenced, isSuspended: Bool?
    var userDescription, location, birthday: String?
    var fields: [String?]?
    var followersCount, followingCount, notesCount: Int?
    var pinnedNoteIds: [String?]?
    var pinnedNotes: [NoteModel?]?
    var pinnedPageId, pinnedPage: String?
    var twoFactorEnabled, usePasswordLessLogin, securityKeys: Bool?
    var twitter, github, discord: String?
    var hasUnreadSpecifiedNotes, hasUnreadMentions: Bool?
}

struct Emoji: Codable {
    let name: String?
    let host: String?
    let url: String?
    let aliases: [String?]?
    let id, updatedAt: String?
    let category: String?
    let uri: String?
    let type: String?
}
