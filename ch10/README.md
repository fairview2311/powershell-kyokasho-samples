# 第10章　Microsoft 365 と Entra ID を Graph で操作する

本の第10章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch10/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- 入社・異動・退職の CSV から、Microsoft 365 のユーザーの作成・ライセンスの割り当て・サインインの停止をまとめて行える

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。

2. Microsoft Graph PowerShell のインストールと、`Connect-MgGraph` での接続は、本の第10章の section 01・02 のとおりに行います。練習用のテナント（Microsoft 365 の試用版など）で試します。

3. 練習用のユーザーを作ってから、本の第10章のとおりに Sync-M365Users を実行します。

   ```text
   cd $HOME\MidoriTools
   .\New-PracticeM365.ps1
   ```

## うまくいったかの確かめ方

- Microsoft 365 管理センターのユーザーの一覧に、練習用のユーザーが表示される

動作しないときは、本の第10章の「うまくいかないとき」を見てください。

<details>
<summary>第9章からの変更（追加・変更したファイル 3 個）</summary>

- 追加: [`New-PracticeM365.ps1`](New-PracticeM365.ps1)
- 変更: [`MidoriTools/MidoriTools.psd1`](MidoriTools/MidoriTools.psd1)
- 変更: [`MidoriTools/MidoriTools.psm1`](MidoriTools/MidoriTools.psm1)

</details>

← [ch09](../ch09)　｜　[一覧](../README.md)　｜　[ch11](../ch11) →
