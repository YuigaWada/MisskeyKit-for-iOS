//  CallbackTypealias.swift
//  MisskeyKit
//
//  Created by Yuiga Wada on 2019/11/05.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//


public typealias AuthCallBack = (MisskeyKit.Auth?, Error?)->Void
public typealias BooleanCallBack = (Bool, Error?)->Void
public typealias NotesCallBack = ([NoteModel]?, Error?)->Void
public typealias OneNoteCallBack = (NoteModel?, Error?)->Void

public typealias OneUserCallBack = (UserModel?, Error?)->Void
public typealias UsersCallBack = ([UserModel]?, Error?)->Void

public typealias NotificationsCallBack = ([NotificationModel]?, Error?)->Void

