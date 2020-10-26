# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    # @tasks = Task.all
    @tasks = current_user.tasks # Userオブジェクトに紐づくタスクオブジェクト一覧を取得
  end

  def show
    # @task = Task.find(params[:id]) # この状態だと、ユーザを特定しないため、全ユーザの指定idのタスクを取得する(findは取得の一番最初の値を採用している)
    @task = current_user.tasks.find(params[:id]) # Userオブジェクトに紐づく(:id)タスクオブジェクトを取得
  end

  def new
    @task = Task.new
    # Controller instance variables can also be viewed from the View
    # You can put the data you want to pass from an Action to a View in an instance variable(The Role of Action)
    # You can specify the screen to be returned to the browser, but you can also omit it.
    # If omitted, it returns the view corresponding to the action
  end

  def create
    # @task = Task.new(task_params.merge(user_id: current_user.id)) # Create a Task object by retrieving the secured value in task_params
    @task = current_user.tasks.new(task_params) # Userオブジェクトに紐づくタスクオブジェクトを生成
    if @task.save # Once the task instance is saved,
      redirect_to tasks, notice: "タスク「#{@task.name}」を登録しました。"
    # if it's not the page you were on when you registered, you can redirect to the specified URL
    # If nothing is specified, render will return to the original page (new)
    else
      render :new
    end
  end

  def edit
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id]) # Userオブジェクトに紐づく(:id)タスクオブジェクトを取得
  end

  def update
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id]) # Userオブジェクトに紐づく(:id)タスクオブジェクトを取得
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    # task = Task.find(params[:id])
    task = current_user.tasks.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
