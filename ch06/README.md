# 第6章　変数・条件・繰り返しを整理し、関数とモジュールにまとめる

本の第6章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch06/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 売上の集計と古いファイルの移動を、モジュール MidoriTools の関数として呼び出せる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。第5章の Get-SalesSummary.ps1 と第4章の Move-OldFiles.ps1 は、モジュールの関数に置き換わったので、このフォルダーにはありません。

2. モジュールを読み込みます。

   ```text
   cd $HOME\MidoriTools
   Import-Module .\MidoriTools -Force
   Get-Command -Module MidoriTools
   ```

## うまくいったかの確かめ方

- Get-SalesSummary と Move-OldFile が一覧に表示される

動作しないときは、本の第6章の「うまくいかないとき」を見てください。

<details>
<summary>第5章からの変更（追加・変更したファイル 2 個）</summary>

- 追加: [`MidoriTools/MidoriTools.psd1`](MidoriTools/MidoriTools.psd1)
- 追加: [`MidoriTools/MidoriTools.psm1`](MidoriTools/MidoriTools.psm1)

</details>

← [ch05](../ch05)　｜　[一覧](../README.md)　｜　[ch07](../ch07) →
