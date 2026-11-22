# 第12章　古いスクリプトを書き換えて 7 に備える

本の第12章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch12/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 前任者のバッチファイルを書き換えた Backup-Share.ps1 で、共有フォルダーをバックアップできる
- 作業箱が 5.1 と 7 の両方で動くかを、Test-MidoriCompat.ps1 で点検できる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。`old` フォルダーは、書き換える前の前任者のファイルです（Shift-JIS で保存してあります）。

2. バックアップを `-WhatIf` で確かめてから実行し、作業箱を点検します。

   ```text
   cd $HOME\MidoriTools
   .\New-PracticeShare.ps1
   .\Backup-Share.ps1 -WhatIf
   .\Backup-Share.ps1
   .\Test-MidoriCompat.ps1
   ```

## うまくいったかの確かめ方

- `backup\share-日付` に10個のファイルがコピーされる
- Test-MidoriCompat.ps1 が「問題は見つかりませんでした」と表示する

動作しないときは、本の第12章の「うまくいかないとき」を見てください。

<details>
<summary>第11章からの変更（追加・変更したファイル 6 個）</summary>

- 追加: [`Backup-Share.ps1`](Backup-Share.ps1)
- 追加: [`Get-DiskReport.ps1`](Get-DiskReport.ps1)
- 追加: [`Test-MidoriCompat.ps1`](Test-MidoriCompat.ps1)
- 追加: [`old/backup.bat`](old/backup.bat)
- 追加: [`old/diskcheck.vbs`](old/diskcheck.vbs)
- 追加: [`old/pcinfo.bat`](old/pcinfo.bat)

</details>

← [ch11](../ch11)　｜　[一覧](../README.md)
