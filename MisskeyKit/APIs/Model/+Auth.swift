//
//  Auth.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/03.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public extension MisskeyKit.Auth {
    struct Token: Codable {
        var token: String
        var url: String
    }
}
