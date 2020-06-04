//
//  ServiceWorkerModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2020/05/12.
//  Copyright © 2020 Yuiga Wada. All rights reserved.
//

import Foundation

public struct ServiceWorkerModel: Codable {
    public let state: State?
    public let key: String?
    
    public enum State: String, Codable {
        case alreadySubscribed = "already-subscribed"
        case subscribed
    }
}
