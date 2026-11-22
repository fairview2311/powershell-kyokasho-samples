# 第9章　Active Directory のユーザーを一括で処理する

本の第9章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch09/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 入社・異動・退職の CSV から、Active Directory のユーザーの作成・異動・無効化をまとめて行える

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。`data\jinji-202604.csv` が、本で使う入社・異動・退職の一覧です。

2. Active Directory の操作は、練習用のドメインに参加したパソコンで行います。練習用の環境の作り方と、RSAT の ActiveDirectory モジュールの入れ方は、本の第9章にあります。

3. 練習用の OU・グループ・ユーザーを作り、`-WhatIf` で確かめてから実行します。

   ```text
   cd $HOME\MidoriTools
   .\New-PracticeAD.ps1
   Import-Module .\MidoriTools -Force
   Sync-ADUsersFromCsv -Path .\data\jinji-202604.csv -OrgUnit '練習' -WhatIf
   ```

## うまくいったかの確かめ方

- -WhatIf を外して実行すると、作成・異動・無効化の結果が1行ずつ表示される

動作しないときは、本の第9章の「うまくいかないとき」を見てください。

<details>
<summary>第8章からの変更（追加・変更したファイル 4 個）</summary>

- 追加: [`New-PracticeAD.ps1`](New-PracticeAD.ps1)
- 追加: [`data/jinji-202604.csv`](data/jinji-202604.csv)
- 変更: [`MidoriTools/MidoriTools.psd1`](MidoriTools/MidoriTools.psd1)
- 変更: [`MidoriTools/MidoriTools.psm1`](MidoriTools/MidoriTools.psm1)

</details>

← [ch08](../ch08)　｜　[一覧](../README.md)　｜　[ch10](../ch10) →
