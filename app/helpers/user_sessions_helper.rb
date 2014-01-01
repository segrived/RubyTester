module UserSessionsHelper

  def logged?
    session[:user_id] != nil && User.where(id: session[:user_id]).exists?
  end

  def logged_user
    User.find(session[:user_id])
  end

end