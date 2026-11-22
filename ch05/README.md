# 第5章　CSV と Excel を集計する

本の第5章を終えた時点の「作業箱」です。本のコードの枠の上の「サンプルコード　ch05/…」は、このフォルダーのファイルを指します。このフォルダーには、それまでの章で作ったファイルもすべて入っています。

この章でできるようになること:

- Shift-JIS の売上の CSV を読み込み、部署ごとの件数と合計金額を集計できる
- 集計を、Excel で開ける CSV と .xlsx に書き出せる

## この章での使い方

作業箱は、本と同じく `$HOME\MidoriTools`（例 `C:\Users\you\MidoriTools`）に置く前提です。コマンドは、特に断りがなければ Windows Terminal の PowerShell 7 のタブで実行します。.ps1・.psm1・.psd1 は、5.1 でも日本語が文字化けしないよう、BOM 付きの UTF-8 で保存してあります。

1. このフォルダーの中身を `$HOME\MidoriTools` にコピーします。`data\uriage-202610.csv` が、本で使う売上の明細です。

2. 集計を実行します。.xlsx を作る Export-SalesExcel.ps1 は、Excel のデスクトップ版が入ったパソコンで実行します。

   ```text
   cd $HOME\MidoriTools
   .\Get-SalesSummary.ps1
   .\Export-SalesExcel.ps1
   ```

## うまくいったかの確かめ方

- `output` フォルダーに、部署別の集計の CSV と .xlsx ができる

動作しないときは、本の第5章の「うまくいかないとき」を見てください。

<details>
<summary>第4章からの変更（追加・変更したファイル 3 個）</summary>

- 追加: [`Export-SalesExcel.ps1`](Export-SalesExcel.ps1)
- 追加: [`Get-SalesSummary.ps1`](Get-SalesSummary.ps1)
- 追加: [`data/uriage-202610.csv`](data/uriage-202610.csv)

</details>

← [ch04](../ch04)　｜　[一覧](../README.md)　｜　[ch06](../ch06) →
