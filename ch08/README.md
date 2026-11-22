# 第8章　Windows の状態を点検する

本の第8章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch08/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- ディスクの空き・OS・エラーの数を、Test-PcHealth でまとめて点検できる
- インストールされたソフトの一覧を、Get-InstalledSoftware で出せる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。

2. モジュールを読み込み直して、点検します。

   ```text
   cd $HOME\MidoriTools
   Import-Module .\MidoriTools -Force
   Test-PcHealth
   ```

## うまくいったかの確かめ方

- このパソコンの OS・空きGB・空き率・エラー件数が表示される

動作しないときは、本の第8章の「うまくいかないとき」を見てください。

<details>
<summary>第7章からの変更（追加・変更したファイル 2 個）</summary>

- 変更: [`MidoriTools/MidoriTools.psd1`](MidoriTools/MidoriTools.psd1)
- 変更: [`MidoriTools/MidoriTools.psm1`](MidoriTools/MidoriTools.psm1)

</details>

← [ch07](../ch07)　｜　[一覧](../README.md)　｜　[ch09](../ch09) →
