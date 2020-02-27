<img src="./MisskeyKit/Resources/logo.png" width=100%>

[![License][license-image]][license-url]
[![Swift Version][swift-image]][swift-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


## MisskeyKit for iOS

MisskeyKitは直観性を重視したSwift用[Misskey](https://misskey.io)フレームワークです。
([English README](https://github.com/YuigaWada/MisskeyKit-for-iOS))

<br>



## 必要なもの

- [Starscream](https://github.com/daltoniam/Starscream)
- Swift 5

<br>

## 目次

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [導入方法](#%E5%B0%8E%E5%85%A5%E6%96%B9%E6%B3%95)
    - [CocoaPods](#cocoapods)
    - [直接導入するには](#%E7%9B%B4%E6%8E%A5%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B%E3%81%AB%E3%81%AF)
- [使い方](#%E4%BD%BF%E3%81%84%E6%96%B9)
  - [Singleton](#singleton)
  - [インスタンスの変更](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%AE%E5%A4%89%E6%9B%B4)
  - [ユーザー認証](#%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC%E8%AA%8D%E8%A8%BC)
    - [CallBack Pattern](#callback-pattern)
    - [Delegation Pattern](#delegation-pattern)
  - [ユーザー認証 (上級者向け)](#%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC%E8%AA%8D%E8%A8%BC-%E4%B8%8A%E7%B4%9A%E8%80%85%E5%90%91%E3%81%91)
    - [```Session Token```の取得](#session-token%E3%81%AE%E5%8F%96%E5%BE%97)
    - [```Access Token```の取得](#access-token%E3%81%AE%E5%8F%96%E5%BE%97)
    - [```Api Key```の取得](#api-key%E3%81%AE%E5%8F%96%E5%BE%97)
  - [APIキーの再利用](#api%E3%82%AD%E3%83%BC%E3%81%AE%E5%86%8D%E5%88%A9%E7%94%A8)
  - [APIの操作](#api%E3%81%AE%E6%93%8D%E4%BD%9C)
  - [Api-Method 対応表](#api-method-%E5%AF%BE%E5%BF%9C%E8%A1%A8)
  - [絵文字](#%E7%B5%B5%E6%96%87%E5%AD%97)
  - [Streaming API](#streaming-api)
    - [```MisskeyKit.Streaming.connect()```](#misskeykitstreamingconnect)
    - [```MisskeyKit.Streaming.captureNote()```](#misskeykitstreamingcapturenote)
    - [```MisskeyKit.Streaming.isConnected```](#misskeykitstreamingisconnected)
    - [```MisskeyKit.Streaming.stopListening()```](#misskeykitstreamingstoplistening)
  - [```MisskeyKitError```](#misskeykiterror)
- [Contribute](#contribute)
- [Others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<br><br>

## 導入方法

#### CocoaPods
MisskeyKitは[CocoaPods](http://cocoapods.org/)からインストールすることができます。

```ruby
pod 'MisskeyKit'
```

インストール後、```MisskeyKit```を```import```してください


``` swift
import MisskeyKit
```

<!-- #### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/PolioPager.framework` to an iOS project.

```
github "YuigaWada/PolioPager"
``` -->


#### 直接導入するには

 ```MisskeyKit``` ダウンロード後、```carthage update``` を叩いてプロジェクトに追加してください。


<br><br>

## 使い方

### Singleton

MisskeyKitでは、apiキーなどのユーザー情報を何度もメソッドに渡さなくてもいいよう、[Singletonパターン](https://en.wikipedia.org/wiki/Singleton_pattern)を採用しています。

したがって、常に下記のインスタンスを使ってください。

```swift
open class MisskeyKit {
  static public let auth: Auth
  static public var notes: Notes
  static public var users: Users
  static public var groups: Groups
  static public var lists: Lists
  static public var search: Search
  static public var notifications: Notifications
  static public var meta: Meta
```

<br>

### インスタンスの変更

Misskeyのインスタンスを変更する場合は```MisskeyKit.changeInstance()```をお使いください。

```swift
MisskeyKit.changeInstance(instance: "misskey.dev")

```

<br>


### ユーザー認証

Misskeyのユーザー認証には本来、5つのステップが存在します。

1. [デベロッパーセンター](https://misskey.io/dev) にアクセスし、 ```Secret Key``` (いわゆる```appSecret```)を取得する
2. APIを叩き```Session Token```を取得する
3. ユーザーに、ブラウザ上から認証させる
4. ```Access Token```を取得する
5. sha256の計算を経て```Api Key``` を取得する。


<br>

しかし **MisskeyKitはたったワンステップでユーザー認証を行うことができます**。

実装すべきことはただ一つ。```MisskeyKit.auth.viewController```と呼ばれるViewControllerを呼び出すだけです。このVCがアプリ内safariを起動し、必要なトークン、sha256の計算などをやってくれます。

ちなみに、ここではコールバックパターンとデリゲートパターン、どちらとも使えるような設計になっています。

<br>

#### CallBack Pattern

```swift
MisskeyKit.auth.appSecret = "Enter your Secret Key"

let authVC = MisskeyKit.auth.viewController
authVC.resultApiKey() { apiKey in

    guard let apiKey = apiKey else { return }
    print(apiKey) // apiキーが取得できているのを確認できます

}

self.present(authVC, animated: true)
```


#### Delegation Pattern

```swift
class ViewController: UIViewController, AuthViewControllerDelegate {

  func something() {
      MisskeyKit.auth.appSecret = "Enter your Secret Key"

      let authVC = MisskeyKit.auth.viewController
      authVC.delegate = self

      self.present(authVC, animated: true)
  }

  //....

  func resultApiKey(_ apiKey: String?) { // AuthViewControllerDelegateが必要
      guard let apiKey = apiKey else { return }

      print(apiKey) // apiキーが取得できているのを確認できます
  }

```

<br><br>

### ユーザー認証 (上級者向け)

APIを直接叩き、先程書いた5つのステップをそれぞれ個別に辿っていくことも可能です。


#### ```Session Token```の取得

```swift
MisskeyKit.auth.startSession(appSecret: "Enter your appSecret") { auth, error in
    guard let auth = auth, let token = auth.token, error == nil else { /* Error */ return }

    print(token) // Session Tokenが取得できているのを確認できます
}
```

<br>

取得できたら、safari等のwebブラウザを経由してMisskeyのページからユーザーにユーザー認証させましょう。

たとえばこんな感じ。

```swift
MisskeyKit.auth.startSession(appSecret: "Enter your appSecret") { auth, error in
    guard let auth = auth, let token = auth.token, error == nil else { /* Error */ return }

    print(token) // Session Tokenが取得できているのを確認できます

    guard let url = URL(string: token.url) else { /* Error */ return }
    DispatchQueue.main.async {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      }
    }
}
```


#### ```Access Token```の取得

```swift
MisskeyKit.auth.getAccessToken() { auth, error in
    guard let auth = auth, error == nil else { return }

    print(auth.me) // Access Tokenが取得できているのを確認できます
}
```


#### ```Api Key```の取得

```swift
// 正常にAccess Tokenが取得できていればapiキーを取得できます
guard let apikey = MisskeyKit.auth.getAPIKey() else {

      /* Error */

}

```

<br>

### APIキーの再利用

ユーザー認証後、Apiキーを保存してログインを半永続化したい場合は、```MisskeyKit.auth.setAPIKey()```から直接Apiキーを設定することができます。


```swift
MisskeyKit.auth.setAPIKey("Enter saved api key!")

```

<br><br>

### APIの操作

APIが無数にあるので、全て個別に説明していくことはすいませんが面倒くさいので出来ません。

一応3つだけ具体例を書いておくことにします。

<br>

例えば、ユーザーの投稿を実装したい場合、下記のコードを参考にしてください。

(Singletonパターンを採用しているため、一度apiキーをMisskeyKitに渡してしまえば、全メソッドにapiキーが行き渡ります。そのため何度もapiキーをメソッドに送る必要はありません。)

<br>

```swift

 // 一番目の引数"posts"については、apiの目的によって型が変わります。
 // ここでは、投稿したデータそのものがMisskeyのサーバーから返ってくるので、NoteModelが返ってきます。
 // 各モデルについては "./MisskeyKit/APIs/Model"を参照してください。

 MisskeyKit.notes.createNote(text: "Enter some text!") { posts, error in  
            guard let posts = posts, error == nil else { /* Error */ return }

            // createNoteでは投稿したデータそのもののモデルが返ってきます。
            // 投稿したデータが返ってくるという事実自体が、正常にリクエストが処理されたということを意味わけです。

            print(posts)
}
```

２つ目の具体例として、例えばタイムラインを上から100個取得したい時、下記のコードが参考になると思います。


```swift
MisskeyKit.notes.getTimeline(limit: 100) { posts, error in
            guard let posts = posts, error == nil else { /* Error */ return }

            print(posts) // 100個確認できます
}
```

３つ目に特殊なタイプの具体例```MisskeyKit.drive.createFile```について書いておきたいと思います。

```MisskeyKit.drive.createFile```ではアップロードしたい生のデータfileDataの他に、fileTypeを渡す必要があります。

この時fileTypeは[MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Complete_list_of_MIME_types)に則る必要があることに留意してください。

<br>

```swift
MisskeyKit.drive.createFile(fileData: targetImage, fileType: "image/jpeg", name: UUID().uuidString + ".jpeg", isSensitive: false, force: false) { result, error in
    guard let result = result, error == nil else { return }

    print(result.id)
}
```

こんな感じで、apiに対応するメソッドを叩き、コールバックでサーバーからのレスポンスを取得していきます。この形態がMisskeyKitの大原則で、基本的には全てのメソッドが同じ形をしています。

次の項目でAPIとメソッドの対応表を記載しておくので、メソッド探しにお使いください。

<br><br><br>


### Api-Method 対応表

|Misskey API|MisskeyKit Methods|
|---|---|
|users/show|Users.showUser|
|i|Users.i|
|i/favorites|Users.getAllFavorites|
|i/page-likes|Users.getLikedPages|
|i/pages|Users.getMyPages|
|i/update|Users.updateMyAccount|
|i/pin|Users.pin|
|i/unpin|Users.unpin|
|following/create|Users.follow|
|following/delete|Users.unfollow|
|users/followers|Users.getFollowers|
|users/following|Users.getFollowing|
|users/get-frequently-replied-users|Users.getFrequentlyRepliedUsers|
|users/relation|Users.getUserRelationship|
|blocking/create|Users.block|
|blocking/delete|Users.unblock|
|blocking/list|Users.getBlockingList|
|users/report-abuse|Users.reportAsAbuse|
|users/recommendation|Users.getUserRecommendation|
|following/requests/accept|Users.acceptFollowRequest|
|following/requests/cancel|Users.cancelFollowRequest|
|following/requests/reject|Users.rejectFollowRequest|
|notes|Notes.getAllNotes|
|notes/show|Notes.showNote|
|notes/conversation|Notes.getConversation, Notes.getChildren|
|users/notes|Notes.getUserNotes|
|notes/mentions|Notes.getMentionsForMe|
|notes/timeline|Notes.getTimeline|
|notes/global-timeline|Notes.getGlobalTimeline|
|notes/hybrid-timeline|Notes.getHybridTimeline|
|notes/local-timeline|Notes.getLocalTimeline|
|notes/user-list-timeline|Notes.getUserListTimeline|
|notes/featured|Notes.getFeatured|
|notes/create|Notes.createNote, Notes.renote|
|notes/delete|Notes.deletePost|
|notes/favorites/create|Notes.createFavorite|
|notes/favorites/delete|Notes.deleteFavorite|
|notes/reactions|Notes.getReactions|
|notes/reactions/create|Notes.createReaction|
|notes/reactions/delete|Notes.deleteReaction|
|notes/renotes|Notes.getRenotes|
|notes/unrenote|Notes.unrenote|
|notes/replies|Notes.getReplies|
|notes/watching/create|Notes.watchNote|
|notes/watching/delete|Notes.unWatchNote|
|i/read-all-unread-notes|Notes.readAllUnreadNotes|
|notes/polls/vote|Notes.vote|
|auth/session/generate|Auth.startSession|
|meta|Meta.get|
|users/groups/invitations/accept|Groups.acceptInvitation|
|users/groups/invitations/reject|Groups.rejectInvitation|
|users/groups/invite|Groups.invite|
|users/groups/pull|Groups.pullUser|
|users/groups/transfer|Groups.transferUser|
|mute/create|Mute.create|
|mute/delete|Mute.delete|
|mute/list|Mute.getList|
|drive/files/attached-notes|Drive.getAttachedNotes|
|drive/files/delete|Drive.deleteFile|
|drive/files/update|Drive.updateFile|
|drive/files/upload-from-url|Drive.uploadFileFromUrl|
|drive/folders/delete|Drive.deleteFolder|
|drive/folders/update|Drive.updateFolder|
|users/lists/pull|Lists.pullUser|
|users/lists/push|Lists.pushUser|
|users/lists/create|Lists.create|
|users/lists/delete|Lists.delete|
|users/lists/show|Lists.show|
|users/lists/list|Lists.getMyLists|
|users/lists/update|Lists.update|
|i/read-all-messaging-messages|Messaging.readAllMessaging|
|messaging/history|Messaging.getHistory|
|messaging/messages|Messaging.getMessageWithUser, Messaging.create|
|messaging/messages/delete|Messaging.delete|
|messaging/messages/read|Messaging.read|
|users/search|Search.user|
|notes/search|Search.notes|
|notes/search-by-tag|Search.notesByTag|
|i/notifications|Notificaitons.get|
|notifications/mark-all-as-read|Notificaitons.markAllAsRead|





<br><br>

### 絵文字

Misskeyのインスタンスはそれぞれに固有なカスタム絵文字というものを持っていて、そのインスタンス上にいるユーザーはそれらのカスタム絵文字をリアクションや投稿内容に使用することができます。

しかしMisskeyAPIでは、必ずしも投稿やリアクションに使用されているカスタム絵文字の情報がサーバーから送られてくるとは限りません。

またもし絵文字ピッカーのようなものを実装したいとなると、デフォルト絵文字・カスタム絵文字両方のデータが必要となります。

したがって、それらの絵文字情報を取得するメソッドをMisskeyKitは提供しています。


```swift
MisskeyKit.Emojis.getDefault{ result in
guard let result = result else { /* Error */ return }

   dump(result) // デフォルト絵文字の情報が確認できます
}
```

```swift
MisskeyKit.Emojis.getCustom{ result in
guard let result = result else { /* Error */ return }

   dump(result) // カスタム絵文字の情報が確認できます
}
```

一度Misskeyインスタンスのサーバーから絵文字情報を取得してしまえば、MisskeyKit上でデータは再利用されます。したがって、ユーザーがあなたのアプリを終了してしまうまではずっと、絵文字情報を何度もサーバーから取得する必要はなく、オーバーヘッドの軽減が期待されます。



<br><br>

### Streaming API

MisskeyKitはREST APIだけでなく[```streaming API```](https://misskey.io/docs/ja-JP/stream)にも対応しています。


(```Streaming API``` とはクライアントとサーバーを常時つなぎ合わせ、 **ほとんど遅延なしにリアルタイムで** 情報を取得できるような技術です。)

<br>

```Streaming API``` ではHTTPプロトコルではなくWebSocketが使われています。そのため、今まで説明したようなメソッドとは違うメソッドからサーバーとやり取りする必要があるわけです。

MisskeyKitでは、WebSocketについても直感的に操作できるようなメソッドを提供しています。

<br>

#### ```MisskeyKit.Streaming.connect()```


Streaming APIと接続するのもたったワンステップ、 ```MisskeyKit.Streaming.connect()```を使うだけです。

(```MisskeyKit.Streaming```はSingletonなインスタンスを提供していないので、各自自分でインスタンスを生成する必要があります。)

```swift
guard let apiKey = MisskeyKit.auth.getAPIKey() else { return }

let streaming = MisskeyKit.Streaming()
MisskeyKit.streaming.connect(apiKey: apiKey, channels: [.main, .homeTimeline]) { response, channel, type, error in

        // Do something ...

        //apiKey:ユーザーごとのapiキー
        //channels: [SentStreamModel.Channel] 型 / 繋ぎたいチャンネルの種類

        //このクロージャーには開発者がつないだチャンネルからイベントが送られてきます。
        //response: Any? 型 / イベントそのものです. 3つめの引数から型を場合分けし、キャストする必要があります
        //channel: SentStreamModel.Channel? 型 / どのチャンネルから送られてきたのかがわかります
        //type: String? Type / どのタイプのデータが返ってきたのかがわかります。この引数からresponseをキャストしてください。
        //error: Error? Type / 正常に処理できなかった場合、エラーが返ってきます

}

```
<br><br>

#### ```MisskeyKit.Streaming.captureNote()```

```MisskeyKit.Streaming.connect()``` を使ってもキャッチ出来ないイベントが存在します。

たとえば、TLをstreaming apiで取得しても、すでに送られてきた投稿に対して新規のリアクションがついた場合、イベントは送られてきません。

そこでこの問題を対処するために、Misskeyには投稿のキャプチャ機能というものが存在します。(詳しくは [ここ](https://misskey.kurume-nct.com/docs/ja-JP/stream))

<br>

MisskeyKitでは投稿のキャプチャをするメソッド ```MisskeyKit.Streaming.captureNote()```を用意しています。

```swift
do {
  try streaming.captureNote(noteId: "Enter note Id.")
}
catch {
   /* Error */
}
```

投稿をキャプチャした場合その投稿に何らかのアクションがあれば、上で説明した ```MisskeyKit.Streaming.connect()```メソッドのコールバック(クロージャー)に随時イベントが送られていきます。

<br><br>

#### ```MisskeyKit.Streaming.isConnected```

ストリーミングが正常に接続されているかどうか確認することが出来ます。

```swift
guard streaming.isConnected else { return }

// Good.
```

<br><br>

#### ```MisskeyKit.Streaming.stopListening()```

もし特定のチャンネル、キャプチャについて接続を切断したい場合は、 ```MisskeyKit.Streaming.stopListening()```を使ってください。


```swift
streaming.stopListening(channnel: SentStreamModel.Channel)
streaming.stopListening(channnels: [SentStreamModel.Channel])
streaming.stopListening(noteId: String)
streaming.stopListening(noteIds: [String])
```


<br><br>


### ```MisskeyKitError```

開発者側が柔軟にエラーハンドリングを行えるよう、MisskeyKitには独自のError列挙型が存在します。

```swift
public enum MisskeyKitError: Error {

    //サーバーから送られてきたエラーコードと一対一に対応しています

    //400
    case ClientError

    //401
    case AuthenticationError

    //403
    case ForbiddonError

    //418
    case ImAI

    //429
    case TooManyError

    //500
    case InternalServerError



    //MisskeyKitの内部エラー

    case CannotConnectStream

    case NoStreamConnection

    case FailedToDecodeJson

    case FailedToCommunicateWithServer

    case UnknownTypeResponse

    case ResponseIsNull
}
```

<br><br>


## Contribute

 **MisskeyKit** はContributeどしどしお待ちしております。
 ライセンスはMITです。詳しくはLICENSEを読んでください。



## Others

Yuiga Wada -  [WebSite](https://yuiga.dev)
Twitter         - [@YuigaWada](https://twitter.com/YuigaWada)





Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/YuigaWada/MisskeyKit-for-iOS](https://github.com/YuigaWada/MisskeyKit-for-iOS)




[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
