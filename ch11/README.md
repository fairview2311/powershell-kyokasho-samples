# 第11章　毎朝自動で実行し、結果を通知する

本の第11章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch11/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 毎朝の点検の結果を、メールと Teams に通知できる
- タスク スケジューラで、毎朝7時に自動で実行できる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。

2. `morning-settings.psd1` の `ここに…` の値を、自分のアプリの ID・テナント・証明書の拇印・Webhook の URL に置き換えます。値の調べ方は本の第10章の section 07 と、第11章の section 03 にあります。

3. 手で実行して、メールと Teams に届くかを確かめます。タスク スケジューラへの登録は、本の第11章の section 05 のコマンドで行います。

   ```text
   cd $HOME\MidoriTools
   .\Invoke-MorningJob.ps1
   ```

## うまくいったかの確かめ方

- 件名「毎朝の点検」のメールと、Teams の「ワークフロー」のチャットに、同じ内容が届く

動作しないときは、本の第11章の「うまくいかないとき」を見てください。

<details>
<summary>第10章からの変更（追加・変更したファイル 2 個）</summary>

- 追加: [`Invoke-MorningJob.ps1`](Invoke-MorningJob.ps1)
- 追加: [`morning-settings.psd1`](morning-settings.psd1)

</details>

← [ch10](../ch10)　｜　[一覧](../README.md)　｜　[ch12](../ch12) →
