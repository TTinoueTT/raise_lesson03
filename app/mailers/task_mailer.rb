class TaskMailer < ApplicationMailer
  default from: 'taskleaf@example.com' # 送信元アドレスをデフォルト指定

  # タスク登録の通知を送るためのメソッドを追加
  def creation_email(task)
    @task = task
    # 登録したTaskオブジェクトを受け取り、メール本文作成時に利用できるように@変数化
    mail(
      subject: 'タスク作成完了メール',
      to: 'user@example.com',
      from: 'taskleaf@example.com' # アプリケーションから送るメールの送信元アドレス
    )
  end
end
