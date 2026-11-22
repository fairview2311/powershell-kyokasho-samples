# 第7章　エラーを捕まえてログに残す

本の第7章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch07/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 失敗を捕まえて、作業箱の `logs` フォルダーにログを残せる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。

2. モジュールを読み込み直して、ログを書きます。

   ```text
   cd $HOME\MidoriTools
   Import-Module .\MidoriTools -Force
   Write-MidoriLog -Message 'ログの確認'
   ```

## うまくいったかの確かめ方

- `logs\MidoriTools-日付.log` に、INFO の行が書かれる

動作しないときは、本の第7章の「うまくいかないとき」を見てください。

<details>
<summary>第6章からの変更（追加・変更したファイル 2 個）</summary>

- 変更: [`MidoriTools/MidoriTools.psd1`](MidoriTools/MidoriTools.psd1)
- 変更: [`MidoriTools/MidoriTools.psm1`](MidoriTools/MidoriTools.psm1)

</details>

← [ch06](../ch06)　｜　[一覧](../README.md)　｜　[ch08](../ch08) →
