#encoding: utf-8

class UserSessionsController < ApplicationController

  before_filter :login_required, only: [:profile, :logout]

  def login
    if logged?
      redirect_to :root and return
    end
    render :login and return if request.get?
    # Пытаемся авторизироваться на основе введённых данных
    login, password = params[:login], params[:password]
    # Неверные данные аутетнификации
    unless user = User.authenticate(login, password) then
      redirect_to :login, alert: "Неверный логин или пароль" and return
    end
    # Если вход для данного аккаунта запрещен настройками доступа
    unless user.can?("login") then
      redirect_to :login, alert: "Данный аккаунт не может использоваться для входа в систему" and return
    end
    session[:user_id] = user.id
    redirect_to :root
  end

  def profile
    @sessions = TestSession.where(user: current_user).desc(:created_at).limit(10)
  end

  def logout
    session[:user_id] = nil
    redirect_to :root
  end
end