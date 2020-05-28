class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
    #コントローラのインスタンス変数はViewからも見ることができる
    #アクションからビューに受け渡したいデータをインスタンス変数に入れることができる(アクションの役割)
    #ブラウザに返す画面を指定できるが省略もできる、省略の場合はアクション名に対応したViewを返す
  end

  def create
    task = Task.new(task_params) #task_paramsで安全化された値を取得してTaskオブジェクトを作成
    task.save! #taskインスタンスが保存されれば↓
    redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
    #データを登録した後に登録時にいたページ以外ならredirectで指定URLに飛ぶ
    #何も指定しなければrenderで元のページにもどる
  end

  def edit
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
