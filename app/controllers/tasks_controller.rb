# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    # @tasks = Task.all
    @q = current_user.tasks.ransack(params[:q]) # ransackでタスク情報を取得するようにする
    # @tasks = current_user.tasks.recent # Userオブジェクトに紐づくタスクオブジェクト一覧を取得
    @tasks = @q.result(distinct: true).page(params[:page]) # 検索結果のデータを取得
    respond_to do |format| # indexに接続した場合、HTMLとして
      format.html
      format.csv do
        send_data @tasks.generate_csv,
                  filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      end
    end
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: 'CSVの一括登録を行いました'
  end

  def show
    # @task = Task.find(params[:id]) # この状態だと、ユーザを特定しないため、全ユーザの指定idのタスクを取得する(findは取得の一番最初の値を採用している)
  end

  def new
    @task = Task.new
    # Controller instance variables can also be viewed from the View
    # You can put the data you want to pass from an Action to a View in an instance variable(The Role of Action)
    # You can specify the screen to be returned to the browser, but you can also omit it.
    # If omitted, it returns the view corresponding to the action
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    # @task = Task.new(task_params.merge(user_id: current_user.id)) # Create a Task object by retrieving the secured value in task_params
    @task = current_user.tasks.new(task_params) # Userオブジェクトに紐づくタスクオブジェクトを生成
    if params[:back].present?
      render :new
      return
    end

    if @task.save # Once the task instance is saved,
      TaskMailer.creation_email(@task).deliver_now
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    # if it's not the page you were on when you registered, you can redirect to the specified URL
    # If nothing is specified, render will return to the original page (new)
    else
      render :new
    end
  end

  def edit
    # @task = Task.find(params[:id])
  end

  def update
    # @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    # task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  # def task_logger
  #   @task_logger ||= Logger.new('log/task.log', 'daily')
  # end

  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
