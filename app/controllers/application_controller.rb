class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper
  include UserSessionsHelper

  before_filter :set_locale

  if Rails.env.production?
    rescue_from Mongoid::Errors::DocumentNotFound, with: :render_404
  end

  # === BEFORE FILTERS
  def login_required
    unless logged? then
      redirect_to :login and return
    end
  end

  def check_permissions(p)
    unless (logged? && logged_user.can?(p)) then
      render_403 and return
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  # === /BEFORE FILTERS

  private

  def render_error(code)
    respond_to do |type|
      type.html { render template: "shared/errors/#{code}", layout: 'application', status: code }
      type.all  { render nothing: true, status: code }
    end
  end

  def render_403; render_error 403; end
  def render_404; render_error 404; end
end
