@{
    # 第10章で登録したアプリと証明書
    ClientId              = 'ここにアプリケーション (クライアント) ID'
    TenantId              = 'ここにテナントのドメイン（例 contoso.onmicrosoft.com）'
    CertificateThumbprint = 'ここに証明書の拇印'

    # 結果を送るメール（送信元は、ライセンスのあるユーザーのメールボックス）
    MailFrom              = 'yamada-taro@contoso.onmicrosoft.com'
    MailTo                = 'yamada-taro@contoso.onmicrosoft.com'

    # Teams の Webhook の URL（Power Automate のフローで作る）
    TeamsWebhookUrl       = 'ここに Webhook の URL'

    # 点検するパソコン（空なら、このパソコンだけ）
    ComputerName          = @()

    # ディスクの空きがこの割合（%）より少なければ注意にする
    MinFreePercent        = 15
}
