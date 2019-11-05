 //
 //  +Notes.swift
 //  MisskeyKit
 //
 //  Created by Yuiga Wada on 2019/11/04.
 //  Copyright © 2019 Yuiga Wada. All rights reserved.
 //

 import Foundation

 public class NoteModel: Codable {
    let id, createdAt, userId: String?
    let user: UserModel?
    let text, cw: String?
    let visibility: Visibility?
    let viaMobile: Bool?
    let isHidden: Bool?
    let renoteCount, repliesCount: Int?
    let reactions: [Reaction?]?
    let emojis: [Emoji?]?
    let files: [File?]?
    let replyId, renoteId: String?
    let renote: NoteModel?
    let mentions: [String?]?
    let visibleUserIds:[String?]?
    let reply: NoteModel?
    let tags: [String]?
    let myReaction: String?
    let fileIds: [String?]?
    let app: App?
    let poll: Poll?
    let geo: Geo?
 }
 
 public class App: Codable {
     let id, name, callbackUrl: String?
     let permission: [String]?
 }

 // MARK: - File
 public struct File: Codable {
     let id, createdAt, name, type: String?
     let md5: String?
     let size: Int?
     let isSensitive: Bool?
     let properties: Properties?
     let url, thumbnailUrl: String?
     let folderId, folder, user: String?
 }

 // MARK: - Properties
 public struct Properties: Codable {
     let width, height: Int?
     let avgColor: String?
 }

 // MARK: - Reaction
 public struct Reaction: Codable {
    let name: String?
    let count: String?
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
     let coordinates: [String?]?
     let altitude, accuracy, altitudeAccuracy, heading: Int?
     let speed: Int?
     
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
     let choices: [Choice?]?
     let multiple: Bool?
     let expiresAt, expiredAfter: String?
     
     public init() {
         self.multiple = nil
         self.choices = nil
         self.expiredAfter = nil
         self.expiresAt = nil
     }
 }

 
 public struct Choice: Codable {
     let text: String?
     let votes: Int?
     let isVoted: Bool?
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
