# NearBuy

## Team NearBuy「Regi-Urico」 API

## エレベーターピッチ

### 購入者側
「人気のブースにいったのに売り切れていた」、「あの出店の商品がどのくらい後に売り切れるのかわからない」問題を解決したい。
「即売会の購入者」、「文化祭の来場者」向けに、「売り切れ前に買える！」を実現するサービス、「Regi-Urico」です。

これは、気になる出店者の在庫情報をリアルタイムに調べることができ、
出店者のTwitterを見続けることと比べて、在庫情報が自動的・リアルタイムに更新される、という優位性があります。

### 販売者側

「在庫管理が面倒」、「在庫数の通知を投稿するのが2度手間」、「どのくらいの在庫を確保すればいいかわからない」問題を解決したい。
「即売会の販売者」、「文化祭の出店者」向けに、「効率的な販売管理を、あなたに。」を実現するサービスです。

これは、在庫情報更新と連携したSNSによる在庫情報公開の自動化、過去の在庫状況の変化から算出する時間経過による売り上げの予測ができ、
他の個人事業主向けの在庫管理アプリに比べて、購入者への通知の自動化、時間単位の売り上げの可視化・購入者との共有ができる、という優位性があります。

## URL
- Twitter: https://twitter.com/nearbuy_enpit17
- アプリ:  http://210.140.221.144/
- タスクボード:
  - -10/25 https://trello.com/b/h1uiYFdg/task-board
  - 10/27- https://trello.com/b/h1uiYFdg/task-board-10-27
  - 11/10- https://trello.com/b/bZkIE7zu/task-board-11-10
  - 11/27- https://trello.com/b/j2ztJ1Gq/task-board-11-27

## Member

- 高橋 <[shuuji3](https://github.com/shuuji3)>
- 漆山 <[urushiyama](https://github.com/urushiyama)>
- 長谷川 <[HasegawaYohei](https://github.com/HasegawaYohei)>
- 藤谷 <[FujitaniTomoki](https://github.com/FujitaniTomoki)>
- 水野 <[3zUn0](https://github.com/3zUn0)>
- 小林 <[kajyuuen](https://github.com/kajyuuen)>

# API ドキュメント

## Table of Contents

* 販売者
  * [POST [/sellers]](#post-sellers)
  * [POST [/signin]](#post-signin)
* Event
  * [GET [/events]](#get-events)
  * [POST [/events]](#post-events)
  * [PATCH [/events]](#patch-events)
  * [DELETE [/events]](#delete-events)
* Event Item
  * [GET [/event\_items/:event\_id]](#get-event_itemsevent_id)
  * [PATCH [/event\_items]](#patch-event_items)
  * [DELETE [/event\_items]](#delete-event_items)
  * [POST [/event\_items]](#post-event_items)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc.go)

## POST [/sellers]

販売者を新規登録する。

### request

```json
{
    "name": "kajyuuen",
    "password": "password",
    "password_confirmation": "password"
}
```

### response

作成成功

```json
{
    "id": 13,
    "name": "kajyuuen",
    "token": "a2jU5ZFtHxvNEdmdXCQkHTgT"
}
```

作成失敗

```json
{
    "errors": {
        "password_confirmation": [
            "doesn't match Password"
        ],
        "name": [
            "has already been taken"
        ]
    }
}
```

## POST [/signin]

登録済みの販売者でサインインして、トークンを取得する。

### request

```json
{
    "name": "kajyuuen",
    "password": "password",
}
```

### response

作成成功

```json
{
    "id": 13,
    "name": "kajyuuen",
    "token": "a2jU5ZFtHxvNEdmdXCQkHTgT"
}
```

作成失敗

```json
{
    "errors": {
        "password_confirmation": [
            "doesn't match Password"
        ],
        "name": [
            "has already been taken"
        ]
    }
}
```

## PATCH [/sellers]

トークンで認証された販売者のアカウント名やパスワードを変更する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "name": "urushiyama",
    "password": "password"
}
```

#### 一部だけを変更する

`name`だけ変えたいときには

```json
{
    "name": "urushiyama"
}
```

あるいは

```json
    "name": "urushiyama",
    "password": ""
```

`password`についても`name`と同様である。

### response

更新成功

```json
{
    "id": 1,
    "name": "urushiyama",
    "token": "q2w5ARRr62KEZqGSUGCfzjE6"
}
```

更新失敗

```
HTTP 400 Bad Request
```

```json
{
    "errors": {
        "name": ["can't be blank"],
        "password": ["can't be blank"]
    }
}
```

トークン認証失敗

```
HTTP 401 Unauthorized
```

```json
{
    "errors": {
        "token": ["is unauthorized"]
    }
}
```

## DELETE [/sellers]

トークンで認証された販売者のアカウントを削除する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "password": "password"
}
```

### response

削除成功

```
HTTP 204 No Content
```

パスワードの不一致による削除失敗

```
HTTP 400 Bad Request
```

```json
{
    "errors": {
        "password": ["is incorrect"]
    }
}
```

トークン認証失敗

```
HTTP 401 Unauthorized
```

```json
{
    "errors": {
        "token": ["is unauthorized"]
    }
}
```

## GET [/events]

販売者が作ったイベント一覧を取得する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

### response

作成成功

```json
{
    "event": [
        {
            "id": 9,
            "name": "FULL CODE 5",
            "created_at": "2017-12-01T07:07:03.000Z",
            "updated_at": "2017-12-01T07:07:03.000Z",
            "seller_id": 3
        }
    ]
}
```

作成失敗

```json
{
    "errors": "Unauthorized"
}
```

## POST [/events]

新しいイベントを作成する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "name": "コミケ2017冬"
}
```

### response

作成成功

```json
{
    "id": 12,
    "name": "コミケ2017冬",
}
```

作成失敗

```json
{
    "errors": "Unauthorized"
}
```

## PATCH [/events]

登録済みイベントの情報を修正する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "event_id": 13,
    "name": "新しいイベント名"
}
```

### response

作成成功

```json
{
    "id": 13,
    "name": "新しいイベント名"
}
```

作成失敗

```json
{
    "errors": "Unauthorized"
}
```

## DELETE [/events]

イベントを削除する。レスポンスでは、最後に更新されたイベントが返ってくる。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "event_id": 13
}
```

### response

作成成功

```json
{
    "id": 12,
    "name": "最後に更新されたイベント"
}
```

作成失敗

```json
{
    "errors": "Unauthorized"
}
```

## GET [/event_items/:event_id]

指定したイベントのアイテムリストを取得する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```
/event_items/1
/event_items/999 # 存在しない event_id の場合
```

### response

イベントが存在する場合、最新のアイテム一覧が返ってきます。

```
HTTP 200 OK
```

```json
{
    "items": [
        {
            "item_id": 1,
            "event_id": 1,
            "name": "1",
            "price": 1400,
            "count": 100
        },
        {
            "item_id": 2,
            "event_id": 1,
            "name": "新しい本のタイトル",
            "price": 10000,
            "count": 20
        }
    ]
}
```

指定したイベントが存在しなかった場合、または指定したイベントが自分のものでなかった場合、HTTP 404とともに、空のアイテムリストが返ります。

```
HTTP 404 Not Found
```

```json
{
    "items": []
}
```

認証失敗

```
HTTP 401 Unauthorised
```

```json
{
    "errors": "Unauthorized"
}
```


## PATCH [/event_items]

アイテムの情報を更新する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "event_id": 1,
    "item_id": 2,
    "price": 10000,
    "name": "新しい本のタイトル"
}
```

### response

更新に成功した場合、更新後の最新のアイテム一覧が返ってきます。

```
HTTP 200 OK
```

```json
{
    "items": [
        {
            "item_id": 1,
            "event_id": 1,
            "name": "1",
            "price": 1400,
            "count": 100
        },
        {
            "item_id": 2,
            "event_id": 1,
            "name": "新しい本のタイトル",
            "price": 10000,
            "count": 20
        }
    ]
}
```

指定したアイテムが存在しなかった場合は、HTTP404とともに、最新のアイテム一覧が返ってきます。

```
HTTP 404 Not Found
```

```json
{
    "items": [
        {
            "event_id": 3,
            "item_id": 11,
            "name": "2冊目の本のタイトル",
            "price": 500,
            "count": 50,
        },
        {
            "event_id": 3,
            "item_id": 12,
            "name": "3冊目の本のタイトル",
            "price": 700,
            "count": 100,
        }
    ]
}
```

認証失敗

```
HTTP 401 Unauthorised
```

```json
{
    "errors": "Unauthorized"
}
```

## DELETE [/event_items]

アイテムを削除する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "event_id": 3,
    "item_id": 10
}
```

### response

削除に成功した場合、更新後のアイテム一覧が返ってきます。

```
HTTP 200 OK
```

```json
{
    "items": [
        {
            "event_id": 3,
            "item_id": 11,
            "name": "2冊目の本のタイトル",
            "price": 500,
            "count": 50,
        },
        {
            "event_id": 3,
            "item_id": 12,
            "name": "3冊目の本のタイトル",
            "price": 700,
            "count": 100,
        }
    ]
}
```

削除するアイテムが存在しなかった場合は、HTTP404とともに、最新のアイテム一覧が返ってきます。

```
HTTP 404 Not Found
```

```json
{
    "items": [
        {
            "event_id": 3,
            "item_id": 11,
            "name": "2冊目の本のタイトル",
            "price": 500,
            "count": 50,
        },
        {
            "event_id": 3,
            "item_id": 12,
            "name": "3冊目の本のタイトル",
            "price": 700,
            "count": 100,
        }
    ]
}
```

認証失敗

```
HTTP 401 Unauthorised
```

```json
{
    "errors": "Unauthorized"
}
```

## POST [/event_items]

イベントに新しいアイテムを登録する。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```

```json
{
    "event_id": 4,
    "price": 10000,
    "count": 200,
    "name": "高級ブック"
}
```

### response

登録に成功した場合、登録後の最新のアイテムリストが返ります。

```
HTTP 200 OK
```

```json
{
    "items": [
        {
            "event_id": 4,
            "item_id": 1,
            "name": "安い本",
            "price": 100,
            "count": 20
        },
        {
            "event_id": 4,
            "item_id": 2,
            "name": "高級ブック",
            "price": 10000,
            "count": 200
        }
    ]
}
```

必要な情報不足により作成失敗 (i.e. `item_name`が存在しないなど)

```
HTTP 400 Bad Request
```

```json
{
    "errors": "Validation failed: Name can't be blank"
}
```

認証失敗

```
HTTP 401 Unauthorised
```

```json
{
    "errors": "Unauthorized"
}
```

## POST [/register]

レジで商品が購入された時、商品在庫数の増減を登録します。

### request

```
X-Authorized-Token: q2w5ARRr62KEZqGSUGCfzjE6
```


```json
{
    "event_id": 1,
    "items": [
        {
            "id": 1,
            "name": "Book1",
            "count": 3
        },
        {
            "id": 2,
            "name": "Book2",
            "count": 5
        },
    ]
}
```

### response

登録に成功した場合、登録後の最新のアイテムリストが返ります。

```
HTTP 201 Created
```

```json
{
    "id": 1,
    "name": "イベント名",
    "event_items": [
        {
            "price": 1400,
            "item_id": 1,
            "name": "Book1",
            "count": 19,
            "diff_count": 0
        },
        {
            "price": 600,
            "item_id": 2,
            "name": "Book2",
            "count": 28,
            "diff_count": 0
        }
    ]
}
```

指定したアイテムが存在しない、または他人のアイテムだった場合

```
HTTP 400 Bad Request
```

```json
{
    "errors": "there is no such item, event_id: 999, item_id: 777"
}
```
