# PowerShellの教科書 サンプルコード

書籍『PowerShellの教科書 Active Directory・Microsoft 365・CSV集計・定期実行の自動化』（早瀬 透）のサンプルコードです。

本では、みどり文具株式会社のひとり情シスが、手作業を1つずつスクリプトにして「作業箱」（`MidoriTools` フォルダー）を育てます。このリポジトリには、**各章を終えた時点の作業箱** が、章ごとのフォルダー（`ch02`〜`ch12`）に入っています。本文のコードの枠と、その章のフォルダーのファイルは同じ内容です。

- 書いたスクリプトが動かないとき、本のとおりのファイルと比較する
- 本のコードを打つ代わりに、ここからコピーして貼り付ける
- 途中の章から読み始めるとき、前の章の終わりの作業箱をそろえる

といった使い方をしてください。

## 本

- Kindle 版: https://www.amazon.co.jp/dp/B0HSKWVTK6
- ペーパーバック: https://www.amazon.co.jp/dp/B0HSKMWVQS

## 動かすのに必要なもの

- Windows 11（Windows 10 でも、ほとんどのスクリプトは動きます）
- Windows PowerShell 5.1（Windows に最初から入っています）と、PowerShell 7.6 LTS
- 第5章の .xlsx の作成は Excel のデスクトップ版、第9章は練習用の Active Directory、第10・11章は練習用の Microsoft 365 のテナント

PowerShell 7.6 LTS と Windows Terminal・VS Code の入れ方は、本の第1章にあります。すべてのスクリプトは、5.1 と 7.6 の両方で動くことを確かめています。

## ダウンロードと置き場所

このページの上の緑の［Code］を押し、［Download ZIP］を押します。展開すると `powershell-kyokasho-samples-main` フォルダーができ、その中に `ch02`〜`ch12` があります。

本では、作業箱をホームのフォルダーの `MidoriTools` に置きます。使いたい章のフォルダーの中身を、作業箱にコピーします。

```text
C:\Users\you\
├─ MidoriTools\                       ← 作業箱（本で作るフォルダー）
│   ├─ hello.ps1
│   ├─ MidoriTools\                   ← モジュール（第6章から）
│   └─ …
└─ Downloads\powershell-kyokasho-samples-main\
    ├─ ch02\                          ← 第2章を終えた作業箱
    ├─ …
    └─ ch12\                          ← 完成した作業箱
```

ZIP から取り出したファイルは、インターネットから入手したファイルとしてブロックされ、そのままでは実行できません。コピーした後に、一度だけ次のコマンドでブロックを解除します（本の第2章の section 06）。

```powershell
Get-ChildItem -Path $HOME\MidoriTools -Recurse -File | Unblock-File
```

## 本のコードとファイルの対応

本のコードの枠の上には、次のような行があります。

```text
サンプルコード　ch08/MidoriTools/MidoriTools.psm1
```

この行は、そのコードの枠が、このリポジトリの `ch08` フォルダーの `MidoriTools/MidoriTools.psm1` と同じ内容であることを示します。「（一部）」と付いた枠は、ファイルの一部だけを見せています。前後の行は、フォルダーのファイルで確かめてください。

1つのファイルだけをコピーしたいときは、下の表で章のフォルダーを押し、ファイル名を押して開きます。中身の右上の、四角が2つ重なったボタン（マウスを乗せると「Copy raw file」と出ます）でコピーできます。

## 章ごとのフォルダー

**使い方は、各フォルダーを開くと下に表示されます。**

| 章 | この章の終わりの作業箱 | フォルダー |
|---|---|---|
| 第2章　最初のスクリプトを実行する | hello.ps1 と、ダブルクリックで実行する hello.bat | [ch02](ch02) |
| 第3章　コマンドレットとオブジェクトの読み方 | パソコンの状態を表で見る Get-PcInfo.ps1 | [ch03](ch03) |
| 第4章　ファイルとフォルダーを整理する | 古いファイルを年ごとに移す Move-OldFiles.ps1 | [ch04](ch04) |
| 第5章　CSV と Excel を集計する | 売上の CSV を集計し、Excel に書き出すスクリプト | [ch05](ch05) |
| 第6章　変数・条件・繰り返しを整理し、関数とモジュールにまとめる | 関数をまとめたモジュール MidoriTools | [ch06](ch06) |
| 第7章　エラーを捕まえてログに残す | ログを書く Write-MidoriLog | [ch07](ch07) |
| 第8章　Windows の状態を点検する | 点検の関数 Test-PcHealth・Get-InstalledSoftware | [ch08](ch08) |
| 第9章　Active Directory のユーザーを一括で処理する | AD のユーザーを CSV から処理する Sync-ADUsersFromCsv | [ch09](ch09) |
| 第10章　Microsoft 365 と Entra ID を Graph で操作する | Microsoft 365 のユーザーを処理する Sync-M365Users | [ch10](ch10) |
| 第11章　毎朝自動で実行し、結果を通知する | 毎朝の点検と通知の Invoke-MorningJob.ps1 | [ch11](ch11) |
| 第12章　古いスクリプトを書き換えて 7 に備える | 完成した作業箱と、5.1・7 の点検の Test-MidoriCompat.ps1 | [ch12](ch12) |

第1章はインストールの章なので、フォルダーはありません。途中の章から読み始めるときは、1つ前の章のフォルダーを使います。第8章から読むなら `ch07` です。

## 知っておくこと

- `data` フォルダーの CSV（売上・入社と異動と退職の一覧）は、架空のデータです。会社のシステムが書き出す形をまねて、Shift-JIS で保存してあります
- 第9・10章のスクリプトは、ユーザーを作成・変更します。必ず練習用の環境で試し、`-WhatIf` で確かめてから実行してください
- `morning-settings.psd1`（第11章）の `ここに…` の値は、自分の環境の値に置き換えます。Webhook の URL や証明書の拇印は、パスワードと同じように扱い、Git などに置かないでください
- `ch12/old` は、第12章で書き換える前の前任者のファイル（バッチファイル・VBScript）です
- 本の内容の誤りや、動作しなかったところは、このリポジトリの Issues で教えていただけると助かります
