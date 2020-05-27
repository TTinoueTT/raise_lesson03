class TasksController < ApplicationController
  def index
  end

  def show
  end

  def new
    @task = Task.new
    #コントローラのインスタンス変数はViewからも見ることができる
    #アクションからビューに受け渡したいデータをインスタンス変数に入れることができる(アクションの役割)
    #ブラウザに返す画面を指定できるが省略もできる、省略の場合はアクション名に対応したViewを返す
  end

  def edit
  end
end
