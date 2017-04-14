# ocunet3-helper

大阪市立大学のキャンパスネットワーク(OCUNET3)に接続しているMacOS X端末でIPアドレスの取得を素早く行うための非公式なプログラム．

## インストール

- Terminal から `git clone https://github.com/ktabe/ocunet3-helper.git` でダウンロード
- ocunet3-helper ディレクトリの中に `ocunet3-helper.app` があるので， これを `/Applications` などにコピー(もしくは移動)

## 使い方

- `ocunet3-helper.app` をダブルクリックで起動します
- 起動時と終了時にパスワードが聞かれるので入れて下さい．　これは内部的に root ユーザで動作しているためです．

## 効能

- 通常，OCUNET3に接続すると，Web認証画面でパスワードを入れてから実際にネットワークが使えるようになるまで1分程度かかりますが，このプログラムを起動していると，その時間を短縮します．
- 認証VLANからログアウトした後は，概ね30秒以内にWeb認証画面に戻ります．
- 接続状態を通知で表示します．接続時にはVLAN名を表示します．

## 互換性

- 動作は MacOS 10.11 (El Capitan) および macOS 10.12 (Sierra) で確認しています．
