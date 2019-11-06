//
//  StreamingModel.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/06.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import Foundation

public struct StreamingModel: Codable {
    let id: String?
    let createdAt: String?
    let type: String?
    let userId: String?
    let user: UserModel?
    let note: NoteModel?
}

public struct NoteUpdatedModel: Codable {
    var type: UpdateType?
    var targetNoteId: String?
    
    let deletedAt: String?
    let choice: Int?
    let uesrId: String?
    let reaction: String?

    
    public enum UpdateType: String, Codable {
        case reacted = "reacted"
        case pollVoted = "pollVoted"
        case deleted = "deleted"
    }
    
}



// ** for example **

// "body": {
//     "id": "7zqfs8k66y",
//     "createdAt": "2019-11-06T05:59:22.710Z",
//     "type": "reply",
//     "userId": "7zpjol10yf",
//     "user": {UserModel},
//     "note": {NoteModel}
// }
 
