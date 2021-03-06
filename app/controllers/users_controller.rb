class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :login_required, only: %i[ new create ]
  def index
  end
  def new
    if logged_in?
      redirect_to user_path(current_user.id)
    else
      @user = User.new
    end
  end
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
      flash[:success] = "新たなユーザー「#{@user.user_name}」が登録されました"
    else
      render :new
    end
  end
  def show
    if @user.id == current_user.id || current_user.admin?
      @tasks = current_user.tasks.select(:id, :task_name, :discription, :expired_at, :status, :priority, :created_at,).order("created_at DESC")
    else
      redirect_to tasks_path
    end
  end
  def edit
  end
  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:notice] = "ユーザー「#{@user.user_name}」の編集が完了しました"
    else
      render :edit
    end
  end
  def destroy
    @user.destroy
    redirect_to new_user_path
    flash[:notice] = "ユーザーを削除しました"
  end
  private
  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :admin)
  end
  def set_user
    @user = User.find(params[:id])
  end
end
