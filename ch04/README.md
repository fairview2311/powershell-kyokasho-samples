# 第4章　ファイルとフォルダーを整理する

本の第4章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch04/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 練習用の共有フォルダーを作り、1年以上更新されていないファイルを年ごとのフォルダーに移せる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。

2. 練習用の共有フォルダーを作り、Move-OldFiles.ps1 を実行します。最初は、スクリプトの中の `$WhatIfMode` が `$true` なので、何が起きるかだけが表示されます。確かめたら `$false` にして保存し、もう一度実行します（本の第4章の section 04）。

   ```text
   cd $HOME\MidoriTools
   .\New-PracticeShare.ps1
   .\Move-OldFiles.ps1
   ```

## うまくいったかの確かめ方

- `practice\share` の部署ごとのフォルダーに、年ごとのフォルダーができ、古いファイルが移っている

動作しないときは、本の第4章の「うまくいかないとき」を見てください。

<details>
<summary>第3章からの変更（追加・変更したファイル 2 個）</summary>

- 追加: [`Move-OldFiles.ps1`](Move-OldFiles.ps1)
- 追加: [`New-PracticeShare.ps1`](New-PracticeShare.ps1)

</details>

← [ch03](../ch03)　｜　[一覧](../README.md)　｜　[ch05](../ch05) →
