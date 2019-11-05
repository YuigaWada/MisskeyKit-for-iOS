//
//  MetaModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public struct MetaModel: Codable{
    let maintainerName, maintainerEmail, version, name: String?
    let uri: String?
    let welcomeDescription: String?
    let langs: [String]?
    let toSUrl: String?
    let repositoryUrl, feedbackUrl: String?
    let secure: Bool?
    let machine, os, node, psql: String?
    let redis: String?
    let cpu: CPU?
    let announcements: [Announcement]?
    let disableRegistration, disableLocalTimeline, disableGlobalTimeline, enableEmojiReaction: Bool?
    let driveCapacityPerLocalUserMB, driveCapacityPerRemoteUserMB: Int?
    let cacheRemoteFiles, enableRecaptcha: Bool?
    let recaptchaSiteKey, swPublickey, mascotImageUrl: String?
    let bannerUrl: String?
    let errorImageUrl, iconUrl: String?
    let maxNoteTextLength: Int?
    let emojis: [Emoji]?
    let enableEmail, enableTwitterIntegration, enableGithubIntegration, enableDiscordIntegration: Bool?
    let enableServiceWorker: Bool?
    let features: Features?
}

// MARK: - Announcement
public struct Announcement: Codable{
    let text: String?
    let image: String?
    let title: String?
}

// MARK: - CPU
public struct CPU: Codable{
    let model: String?
    let cores: Int?
}

// MARK: - Emoji
public struct Emoji: Codable{
    let id: String?
    let aliases: [String]?
    let name: String?
    let category: Category?
    let url: String?
    let uri: String?
    let type: String?
}

enum Category: String, Codable{
    case logo = "Logo"
    case os = "OS"
    case cute = "かわいい"
    case others = "その他"
    case application = "アプリケーション"
    case character = "キャラクター"
    case service = "サービス"
    case deco = "デコ文字"
    case action = "行動"
    case face = "顔"
    case foodAndDrink = "食べ物・飲み物"
}

// MARK: - Features
public struct Features: Codable{
    let registration, localTimeLine, globalTimeLine, elasticsearch: Bool?
    let recaptcha, objectStorage, twitter, github: Bool?
    let discord, serviceWorker: Bool?
}
