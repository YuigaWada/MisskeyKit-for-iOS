 //
 //  +Notes.swift
 //  MisskeyKit
 //
 //  Created by Yuiga Wada on 2019/11/04.
 //  Copyright © 2019 Yuiga Wada. All rights reserved.
 //

 import Foundation

 public class NoteModel: Codable {
    public let id, createdAt, userId: String?
    public let user: UserModel?
    public let text, cw: String?
    public let visibility: Visibility?
    public let viaMobile: Bool?
    public let isHidden: Bool?
    public let renoteCount, repliesCount: Int?
    public let reactions: [Reaction?]?
    public let emojis: [EmojiModel?]?
    public let files: [File?]?
    public let replyId, renoteId: String?
    public let renote: NoteModel?
    public let mentions: [String?]?
    public let visibleUserIds:[String?]?
    public let reply: NoteModel?
    public let tags: [String]?
    public let myReaction: String?
    public let fileIds: [String?]?
    public let app: App?
    public let poll: Poll?
    public let geo: Geo?
 }
 
 public class App: Codable {
     public let id, name, callbackUrl: String?
     public let permission: [String]?
 }

 // MARK: - File
 public struct File: Codable {
     public let id, createdAt, name, type: String?
     public let md5: String?
     public let size: Int?
     public let isSensitive: Bool?
     public let properties: Properties?
     public let url, thumbnailUrl: String?
     public let folderId, folder, user: String?
 }

 // MARK: - Properties
 public struct Properties: Codable {
     public let width, height: Int?
     public let avgColor: String?
 }

 // MARK: - Reaction
 public struct Reaction: Codable {
    public let name: String?
    public let count: String?
 }

 // MARK: - Visibility
 public enum Visibility: String, Codable {
     case `public` = "public"
     case home = "home"
     case followers = "followers"
     case specified = "specified"
 }

 // MARK: - Geo
 public struct Geo: Codable {
     public let coordinates: [String?]?
     public let altitude, accuracy, altitudeAccuracy, heading: Int?
     public let speed: Int?
     
     public init(){
         self.coordinates = []
         self.altitude = 0
         self.accuracy = 0
         self.altitudeAccuracy = 0
         self.heading = 0
         self.speed = 0
     }
 }

 // MARK: - Poll
 public struct Poll: Codable {
     public let choices: [Choice?]?
     public let multiple: Bool?
     public let expiresAt, expiredAfter: String?
     
     public init() {
         self.multiple = nil
         self.choices = nil
         self.expiredAfter = nil
         self.expiresAt = nil
     }
 }

 
 public struct Choice: Codable {
     public let text: String?
     public let votes: Int?
     public let isVoted: Bool?
 }


 
 extension Geo {
    func toDictionary()-> Dictionary<String, Any> {
        return [
            "coordinates": coordinates as Any,
            "altitude":altitude as Any,
            "accuracy":accuracy as Any,
            "altitudeAccuracy":altitudeAccuracy as Any,
            "heading":heading as Any,
            "speed":heading as Any
        ]
    }
 }
 
 extension Poll {
    func toDictionary()-> Dictionary<String, Any> {
        return [
            "multiple": multiple as Any,
            "choices":choices as Any,
            "expiresAt":expiresAt as Any,
            "expiredAfter":expiredAfter as Any
        ]
    }
 }
