#encoding: utf-8

class Admin::UsersController < Admin::AdminController
  def index
    @users = User.scoped
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save then
      redirect_to :admin_users and return
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user]) then
      redirect_to :admin_users
    else
      render :edit
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    user = User.find(params[:id])
    if user.id == current_user.id
      render_403
    else
      user.destroy
      redirect_to :admin_users
    end
  end
end