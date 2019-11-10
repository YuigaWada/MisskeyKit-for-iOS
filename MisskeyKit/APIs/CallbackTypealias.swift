//  CallbackTypealias.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//


public typealias AuthCallBack = (MisskeyKit.Auth?, Error?)->Void
public typealias BooleanCallBack = (Bool, Error?)->Void
public typealias OneNoteCallBack = (NoteModel?, Error?)->Void
public typealias NotesCallBack = ([NoteModel]?, Error?)->Void

public typealias OneUserCallBack = (UserModel?, Error?)->Void
public typealias UsersCallBack = ([UserModel]?, Error?)->Void

public typealias OneUserRelationshipCallBack = (UserRelationship?, Error?)->Void
public typealias UserRelationshipsCallBack = ([UserRelationship]?, Error?)->Void

public typealias ReactionsCallBack = ([ReactionModel]?, Error?)->Void

public typealias NotificationsCallBack = ([NotificationModel]?, Error?)->Void

public typealias OneMessageCallBack = (MessageModel?, Error?)->Void
public typealias MessagesCallBack = ([MessageModel]?, Error?)->Void

public typealias MutesCallBack = ([MuteModel]?, Error?)->Void

public typealias ListCallBack = (ListModel?, Error?)->Void
public typealias ListsCallBack = ([ListModel]?, Error?)->Void

public typealias PagesCallBack = ([PageModel]?, Error?)->Void

public typealias BlockListCallBack = ([BlockList]?, Error?)->Void

public typealias MetaCallBack = (MetaModel?, Error?)->Void
