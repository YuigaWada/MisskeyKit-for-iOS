//
//  Emoji.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/09.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

extension MisskeyKit {
    public class Emojis {
        private let meta: Meta
        
        required init(from meta: Meta) {
            self.meta = meta
        }
        
        private var bundle = Bundle(for: MisskeyKit.self)
        private var customEmojis: [EmojiModel]?
        private var defaultEmoji: [DefaultEmojiModel]?
        
        public func getDefault(completion: @escaping (([DefaultEmojiModel]?) -> Void)) {
            if let defaultEmoji = defaultEmoji {
                completion(defaultEmoji)
                return
            }
            
            // If defaultEmoji was not set ...
            
            guard let path = bundle.path(forResource: "emojilist",
                                         ofType: "json")
            else { completion(nil); return }
            
            DispatchQueue.global(qos: .default).async {
                do {
                    let rawJson = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                    self.defaultEmoji = rawJson.decodeJSON([DefaultEmojiModel].self)
                } catch { completion(nil); return }
                
                completion(self.defaultEmoji)
            }
        }
        
        public func getCustom(completion: @escaping (([EmojiModel]?) -> Void)) {
            if let customEmojis = customEmojis {
                completion(customEmojis)
                return
            }
            
            
            meta.getEmojis { result, error in
                guard let result = result, error == nil else { completion(nil); return }
                
                self.customEmojis = result
                completion(self.customEmojis)
            }
        }
    }
}

public struct DefaultEmojiModel: Codable {
    public let category: Category?
    public let char, name: String?
    public let keywords: [String]?
    
    public enum Category: String, Codable {
        case activity
        case animalsAndNature = "animals_and_nature"
        case flags
        case foodAndDrink = "food_and_drink"
        case objects
        case people
        case symbols
        case travelAndPlaces = "travel_and_places"
    }
}
