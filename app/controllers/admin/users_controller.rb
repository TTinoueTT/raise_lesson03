class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.save
      redirect_to admin_user_path(user_params), notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :new
    end
  end

  def delete
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def require_admin
    redirect_to root_path unless current_user.admin? # current_userが管理者権限でないなら、root_pathに転送
    # 簡単な例のため、root_pathに転送する処理を行なっているが、これを行うことで、usersコントローラのアクションが存在していることを知らしめてしまう
    # 管理機能の存在を隠すのであれば、HTTPステータスコード404を返すコードを書く方が良い
  end
end
