module UserSessionsHelper

  mattr_accessor :current_user, :is_logged

  def logged?
    self.is_logged
  end

  def retrieve_current_user
    self.current_user = User.where(id: session[:user_id]).first
    self.is_logged = !self.current_user.nil?
  end

end